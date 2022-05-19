//
//  ContestStrategy.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import Foundation
import TinkoffInvestSDK
import CombineGRPC
import Combine

class ContestStrategy {

    private let sdk: TinkoffInvestSDK
    private let database: IDatabaseService
    private let robot: Robot
    weak var delegate: IStrategyDelegate?
    
    private var cancellables = Set<AnyCancellable>()

    private var deal: Deal?
    private var preDealOrder: Deal.Order?

    init(sdk: TinkoffInvestSDK, database: IDatabaseService, robot: Robot) {
        self.sdk = sdk
        self.database = database
        self.robot = robot
    }

    // State

    private enum State {
        case stopped
        case pending
        case preOpenOrderPosted
        case openOrderPosted(PostOrderResponse, OrderBook)
        case openOrderExecuted
        case preCloseOrderPosted
        case closeOrderPosted(PostOrderResponse, OrderBook)
        case error(String)
    }

    private var state: State = .stopped {
        didSet {

            switch state {
            case .error(let message): log(message)
            default: log()
            }

            switch state {
            case .stopped, .pending, .preOpenOrderPosted, .openOrderExecuted, .preCloseOrderPosted:
                break
            case .openOrderPosted(let response, let orderBook):
                preDealOrder = Deal.Order.open(response: response, orderBook: orderBook)
            case .closeOrderPosted(let response, let orderBook):
                preDealOrder = Deal.Order.open(response: response, orderBook: orderBook)
            case .error(let message):
                delegate?.didReceiveError(message)
            }
        }
    }
}

// MARK: IStrategy

extension ContestStrategy: IStrategy {

    var figi: String { config.figi }
    var currency: MoneyCurrency { config.currency }

    var isRunning: Bool {
        if case State.stopped = state {
            return false
        } else {
            return true
        }
    }

    func run() {
        guard !isRunning else { return }
        state = .pending
    }

    func stop() {
        cancelOrder(order: preDealOrder)
        state = .stopped
        preDealOrder = nil
        deal = nil
    }
}

// MARK: IOrderBookStrategy

extension ContestStrategy: IOrderBookStrategy {

    var depth: Int { config.depth }

    var order: PreOrderModel? {
        guard let order = deal?.close ?? preDealOrder else { return nil }
        let section: OrderBookPresenter.Section
        switch order.direction {
        case .buy: section = .bid
        case .sell: section = .ask
        }
        return PreOrderModel(price: order.price, quantity: config.orderQuantity, section: section)
    }

    var stopLoss: PreOrderModel? {
        guard let deal = deal else { return nil }
        let section: OrderBookPresenter.Section
        switch deal.open.direction {
        case .buy: section = .bid
        case .sell: section = .ask
        }
        return PreOrderModel(price: deal.stopLoss, quantity: config.orderQuantity, section: section)
    }

    var takeProfit: PreOrderModel? {
        guard let deal = deal else { return nil }
        let section: OrderBookPresenter.Section
        switch deal.open.direction {
        case .buy: section = .ask
        case .sell: section = .bid
        }
        return PreOrderModel(price: deal.takeProfit, quantity: config.orderQuantity, section: section)
    }

    func receive(orderBook: OrderBook) {
        receive(orderBook: orderBook, state: state)
    }
}

// MARK: Strategy provider

private extension ContestStrategy {

    private func receive(orderBook: OrderBook, state: State) {
        log("Received: orderBook")

        switch state {
        case .pending:
            pending(orderBook)
        case .openOrderPosted(let response, _):
            checkOrderStatus(order: preDealOrder, id: response.orderID, orderBook) { [weak self] in
                self?.openDeal(order: $0.order,
                               orderID: $0.state.orderID,
                               direction: $0.state.direction,
                               price: $0.state.initialOrderPrice.asMoneyAmount.value,
                               orderBook: orderBook)
            }
        case .openOrderExecuted:
            checkClose(orderBook)
        case .closeOrderPosted(let response, _):
            checkOrderStatus(order: preDealOrder, id: response.orderID, orderBook) { [weak self] in
                self?.closeDeal(order: $0.order,
                               orderID: $0.state.orderID,
                               direction: $0.state.direction,
                               price: $0.state.initialOrderPrice.asMoneyAmount.value,
                               orderBook: orderBook)
            }

        case .stopped, .error, .preOpenOrderPosted, .preCloseOrderPosted:
            return
        }
    }

    func pending(_ orderBook: OrderBook) {
        let tuple: (Order, OrderDirection)?

        if config.orderDirection != .sell,
           let bid = orderBook.bids.first(where: { $0.quantity >= config.edgeQuantity }) {
            tuple = (bid, .buy)
        } else if config.orderDirection != .buy,
           let ask = orderBook.asks.first(where: { $0.quantity >= config.edgeQuantity }) {
            tuple = (ask, .sell)
        } else {
            tuple = nil
        }

        guard let tuple = tuple else { return }
        log("\(tuple.1 == .buy ? "Buy" : "Sell"): \(tuple.0.price.asAmount) - \(tuple.0.quantity)")

        state = .preOpenOrderPosted
        postOrder(price: tuple.0.price.asAmount, direction: tuple.1) { [weak self] response in
            self?.log("Response: \(response.executionReportStatus)")
            switch response.executionReportStatus {
            case .executionReportStatusNew, .executionReportStatusPartiallyfill:
                self?.state = .openOrderPosted(response, orderBook)
            case .executionReportStatusFill:
                self?.openDeal(order: nil,
                               orderID: response.orderID,
                               direction: response.direction,
                               price: response.initialOrderPrice.asMoneyAmount.value,
                               orderBook: orderBook)
            case .UNRECOGNIZED(_), .executionReportStatusCancelled, .executionReportStatusRejected, .executionReportStatusUnspecified:
                self?.state = .pending
            }
        }
    }

    func checkOrderStatus(order: Deal.Order?, id: String,
                          _ orderBook: OrderBook,
                          _ onFillCompletion: @escaping ((order: Deal.Order, state: OrderState)) -> Void) {
        guard let order = order else {
            log("CheckOrderStatus: missing order")
            return
        }
        var requestCheck = false
        switch order.direction {
        case .buy:
            if let bid = orderBook.bids.first,
               bid.price.asAmount <= order.price {
                requestCheck = true
            }
        case .sell:
            if let ask = orderBook.asks.first,
               ask.price.asAmount >= order.price {
                requestCheck = true
            }
        }

        guard requestCheck else { return }
        log("CheckOrderStatus (\(id): \(orderBook.asks.first?.price.asAmount ?? 0) | \(orderBook.bids.first?.price.asAmount ?? 0)")

        getOrderState(accountID: config.accountID, orderID: id)
            .sink { [weak self] result in
              switch result {
              case .failure(let error):
                  self?.log("\(error)")
              case .finished:
                  self?.log("GetOrderState finished")
              }
            } receiveValue: {
                if $0.executionReportStatus == .executionReportStatusFill {
                    onFillCompletion((order, $0))
                }
            }.store(in: &cancellables)
    }

    func checkClose(_ orderBook: OrderBook) {
        guard let deal = deal else {
            log("CheckClose: Missing deal")
            return
        }

        var tuple: (price: Decimal, direction: OrderDirection)?
        switch deal.open.direction {
        case .buy:
            if let ask = orderBook.asks.first,
               ask.price.asAmount >= deal.takeProfit {
                tuple = (ask.price.asAmount, .sell)
            } else if let bid = orderBook.bids.first,
                      bid.price.asAmount <= deal.stopLoss {
                tuple = (bid.price.asAmount, .sell)
            }
        case .sell:
            if let ask = orderBook.asks.first,
               ask.price.asAmount >= deal.stopLoss {
                tuple = (ask.price.asAmount, .buy)
            } else if let bid = orderBook.bids.first,
                      bid.price.asAmount <= deal.takeProfit {
                tuple = (bid.price.asAmount, .buy)
            }
        }

        guard let tuple = tuple else { return }
        log("CheckClose \(tuple.1 == .buy ? "Buy" : "Sell"): \(tuple.0)")

        state = .preCloseOrderPosted
        postOrder(price: tuple.0, direction: tuple.1) { [weak self] in
            self?.log("Response: \($0.executionReportStatus)")
            switch $0.executionReportStatus {
            case .executionReportStatusNew, .executionReportStatusPartiallyfill:
                self?.state = .closeOrderPosted($0, orderBook)
            case .executionReportStatusFill:
                self?.closeDeal(order: nil,
                                orderID: $0.orderID,
                                direction: $0.direction,
                                price: $0.initialOrderPrice.asMoneyAmount.value,
                                orderBook: orderBook)
            case .UNRECOGNIZED(_), .executionReportStatusCancelled, .executionReportStatusRejected, .executionReportStatusUnspecified:
                self?.log("Failed to post stop order: \($0.executionReportStatus)")
            }
        }
    }
}

// MARK: Interactor

private extension ContestStrategy {

    func postOrder(price: Decimal, direction: OrderDirection, _ completion: @escaping (PostOrderResponse) -> Void) {
        var request = PostOrderRequest()
        request.price = price.asQuotation
        request.direction = direction
        request.quantity = config.orderQuantity
        request.orderType = .limit
        request.figi = config.figi
        request.accountID = config.accountID

        postOrder(request: request)
            .sink { [weak self] result in
              switch result {
              case .failure(let error):
                  self?.state = .error("\(error)")
              case .finished:
                  self?.log("PostOrder finished")
              }
            } receiveValue: {
                completion($0)
            }.store(in: &cancellables)
    }

    func openDeal(order: Deal.Order?, orderID: String, direction: OrderDirection, price: Decimal, orderBook: OrderBook) {
        guard let openOrder = order ?? Deal.Order.open(orderID: orderID, direction: direction, price: price, orderBook: orderBook),
              let bounds = getStopBounds(orderPrice: price, direction: direction) else {
            preDealOrder = nil
            state = .error("OpenDeal: missing openOrder or bounds (direction: \(direction.rawValue))")
            return
        }

        deal = Deal(robotId: robot.id,
                    open: openOrder.closed(with: orderBook),
                    close: nil,
                    currency: config.currency.rawValue,
                    quantity: Int(config.orderQuantity),
                    stopLoss: bounds.sl,
                    takeProfit: bounds.tp)
        preDealOrder = nil

        state = .openOrderExecuted
    }

    func getStopBounds(orderPrice: Decimal, direction: OrderDirection) -> StopBounds? {
        let stopBounds: StopBounds?

        switch direction {
        case .buy:
            let tp = orderPrice * (1 + Decimal(config.takeProfitPercent) / 100)
            let sl = orderPrice * (1 - Decimal(config.stopLossPercent) / 100)
            stopBounds = StopBounds(sl: sl, tp: tp)
        case .sell:
            let sl = orderPrice * (1 + Decimal(config.stopLossPercent) / 100)
            let tp = orderPrice * (1 - Decimal(config.takeProfitPercent) / 100)
            stopBounds = StopBounds(sl: sl, tp: tp)
        default:
            stopBounds = nil
        }
        return stopBounds
    }

    func closeDeal(order: Deal.Order?, orderID: String, direction: OrderDirection, price: Decimal, orderBook: OrderBook) {
        guard let closeOrder = order ?? Deal.Order.open(orderID: orderID, direction: direction, price: price, orderBook: orderBook),
              let deal = deal?.closed(with: closeOrder, orderBook: orderBook)
        else {
            preDealOrder = nil
            state = .error("OpenDeal: missing deal or closeOrder")
            return
        }

        self.deal = nil
        preDealOrder = nil
        state = .pending
        storeHistory(deal: deal)
    }

    func cancelOrder(order: Deal.Order?) {
        guard let order = order else { return }
        cancelOrder(accountID: config.accountID, orderID: order.id)
            .sink { [weak self] result in
              switch result {
              case .failure(let error):
                  self?.log("\(error)")
              case .finished:
                  self?.log("Order canceled")
              }
            } receiveValue: { [weak self] _ in
                self?.completeDealCancel(order: order)
            }.store(in: &cancellables)
    }

    func completeDealCancel(order: Deal.Order) {
        let deal = Deal(robotId: robot.id,
                        open: self.deal?.open ?? order,
                        close: self.deal?.open != nil ? order : nil,
                        currency: config.currency.rawValue,
                        quantity: Int(config.orderQuantity),
                        stopLoss: self.deal?.stopLoss ?? 0,
                        takeProfit: self.deal?.takeProfit ?? 0)
        storeHistory(deal: deal)
    }
}

// MARK: SDK

extension ContestStrategy {

    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError> {
        return sdk.sandboxService.postOrder(request: request)
    }

    func cancelOrder(accountID: String, orderID: String) -> AnyPublisher<CancelOrderResponse, RPCError> {
        return sdk.sandboxService.cancelOrder(accountID: accountID, orderID: orderID)
    }

    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError> {
        return sdk.sandboxService.getOrderState(accountID: accountID, orderID: orderID)
    }

    func storeHistory(deal: Deal) {
        database.addDeal(deal)
    }
}

// MARK: Helpers

extension ContestStrategy {

    fileprivate struct StopBounds {
        let sl: Decimal
        let tp: Decimal
    }

    var config: ContestStrategy.Config {
        robot.config as! ContestStrategy.Config
    }

    func log(_ message: String = "") {
        print("🤖 [\(state)] \(message)")
    }
}

extension Deal.Order {

    static func `open`(response: PostOrderResponse, orderBook: OrderBook) -> Deal.Order? {
        open(orderID: response.orderID, direction: response.direction, price: response.initialOrderPrice.asMoneyAmount.value, orderBook: orderBook)
    }

    static func `open`(orderID: String, direction: OrderDirection, price: Decimal, orderBook: OrderBook) -> Deal.Order? {
        guard let direction = Deal.Order.Direction(rawValue: direction.rawValue) else { return nil }
        return Deal.Order(id: orderID,
                          opened: Deal.Order.Book(orderBook),
                          closed: nil,
                          direction: direction,
                          price: price)
    }

    func closed(with orderBook: OrderBook) -> Deal.Order {
        return Deal.Order(id: id,
                          opened: opened,
                          closed: Deal.Order.Book(orderBook),
                          direction: direction,
                          price: price)
    }
}

extension Deal.Order.Book {

    init(_ orderBook: OrderBook) {
        self.init(asks: orderBook.asks.map { Order(price: $0.price.asAmount, quantity: $0.quantity) },
                  bids: orderBook.bids.map { Order(price: $0.price.asAmount, quantity: $0.quantity) },
                  date: orderBook.time.date)
    }
}

extension Deal {

    func closed(with closeOrder: Deal.Order, orderBook: OrderBook) -> Deal {
        return Deal(robotId: robotId,
                    open: self.open,
                    close: closeOrder.closed(with: orderBook),
                    currency: currency,
                    quantity: quantity,
                    stopLoss: stopLoss,
                    takeProfit: takeProfit)
    }
}
