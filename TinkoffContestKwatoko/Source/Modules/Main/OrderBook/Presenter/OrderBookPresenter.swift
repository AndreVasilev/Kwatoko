//
//  OrderBookPresenter.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import Combine
import TinkoffInvestSDK

final class OrderBookPresenter: BasePresenter {

    typealias StopBounds = Trade.StopBounds
    typealias Model = ContestStrategy.Config

    enum Section {
        case ask, bid
    }

    struct RequestData {
        let price: Decimal
        let direction: OrderDirection
        let stopLoss: Decimal
        let takeProfit: Decimal
    }

    let interactor: IOrderBookInteractor
    let router: IOrderBookRouter
    weak var viewController: IOrderBookView?
    let robot: Robot
    
    var cancellables = Set<AnyCancellable>()

    // DataSource

    let sections = [Section.ask, .bid]
    var bids = [OrderBookCell.Model]()
    var asks = [OrderBookCell.Model]()

    // State

    enum State {
        case stopped
        case pending
        case postOrder(OrderBook)
        case orderCreated(PostOrderResponse)
        case orderPosted(PostOrderResponse, StopBounds)
        case stopOrder(StopBounds, OrderBook)
        case stopCreated(PostOrderResponse, StopBounds)
        case error
    }

    var trade: Trade?

    var state: State = .stopped {
        didSet {
            switch state {
            case .stopped:
                cancelOrders()
                if let trade = self.trade {
                    interactor.storeHistory(trade: trade)
                    self.trade = nil
                }
            case .pending:
                if let trade = self.trade {
                    interactor.storeHistory(trade: trade)
                    self.trade = nil
                }
            case .postOrder(let orderBook):
                trade = Trade(open: .init(orderBook: orderBook,
                                          date: Date()))
            case .orderCreated(let response):
                trade?.open.response = response
            case .orderPosted(let response, let bounds):
                trade?.open.response = response
                trade?.stopBounds = bounds
            case .stopOrder(_, let orderBook):
                trade?.close = .init(orderBook: orderBook,
                                     date: Date())
            case .stopCreated(let response, _):
                trade?.close?.response = response
            case .error:
                trade?.error = AppError.unknown("")
            }
        }
    }

    init(interactor: IOrderBookInteractor, router: IOrderBookRouter, robot: Robot) {
        self.interactor = interactor
        self.router = router
        self.robot = robot
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToOrderBook()
    }
}

private extension OrderBookPresenter {

    var config: ContestStrategy.Config {
        robot.config as! ContestStrategy.Config
    }

    func subscribeToOrderBook() {
        interactor.subscribeToOrderBook(figi: config.figi, depth: config.depth)
            .sink { result in
              switch result {
              case .failure(let error):
                  print(error)
              case .finished:
                  print("did finish loading marketDataServiceStream")
              }
            } receiveValue: { [weak self] in
                self?.receive(orderBook: $0.orderbook)
            }.store(in: &cancellables)
    }

    func receive(orderBook: OrderBook) {

        switch state {
        case .pending:
            if let tuple = getRequestData(from: orderBook) {
                state = .postOrder(orderBook)
                postOrder(price: tuple.price, direction: tuple.direction)
            }

        case .orderPosted(let response, let stopBounds):
            if let tuple = getRequestData(orderBook: orderBook,
                                          orderResponse: response,
                                          stopBounds: stopBounds) {
                state = .stopOrder(stopBounds, orderBook)
                postOrder(price: tuple.price, direction: tuple.direction)
            }

        case .orderCreated(let response):
            getOrderStatus(response: response, orderBook: orderBook)

        case .stopCreated(let response, _):
            getOrderStatus(response: response, orderBook: orderBook)

        case .postOrder, .stopOrder, .error, .stopped:
            break
        }

        reloadData(orderBook: orderBook)
    }

    func getRequestData(from orderBook: OrderBook) -> (price: Decimal, direction: OrderDirection)? {
        if config.orderDirection != .sell,
           let bid = orderBook.bids.first(where: { $0.quantity >= config.edgeQuantity }) {
            return ((bid.price.asAmount + config.orderDelta), .buy)
        } else if config.orderDirection != .buy,
           let ask = orderBook.asks.first(where: { $0.quantity >= config.edgeQuantity }) {
            return ((ask.price.asAmount - config.orderDelta), .sell)
        } else {
            return nil
        }
    }

    func getRequestData(orderBook: OrderBook,
                        orderResponse: PostOrderResponse,
                        stopBounds: StopBounds) -> (price: Decimal, direction: OrderDirection)? {
        switch orderResponse.direction {
        case .buy: return getRequestData(orderBook: orderBook, ask: stopBounds.tp, bid: stopBounds.sl, stopOrderDirection: .sell)
        case .sell: return getRequestData(orderBook: orderBook, ask: stopBounds.sl, bid: stopBounds.tp, stopOrderDirection: .buy)
        default: return nil
        }
    }

    func getRequestData(orderBook: OrderBook,
                        ask: Decimal,
                        bid: Decimal,
                        stopOrderDirection: OrderDirection) -> (price: Decimal, direction: OrderDirection)? {
        let lastAskPrice = orderBook.asks[0].price.asAmount
        let lastBidPrice = orderBook.bids[0].price.asAmount

        if lastAskPrice >= ask {
            return (lastAskPrice, stopOrderDirection)
        } else if lastBidPrice <= bid {
            return (lastBidPrice, stopOrderDirection)
        } else {
            return nil
        }
    }

    func postOrder(price: Decimal, direction: OrderDirection) {
        var request = PostOrderRequest()
        request.price = price.asQuotation
        request.direction = direction
        request.quantity = config.orderQuantity
        request.orderType = .limit
        request.figi = config.figi
        request.accountID = config.accountID

        interactor.postOrder(request: request)
            .sink { result in
              switch result {
              case .failure(let error):
                  print(error)
              case .finished:
                  print("did finish loading postOrder")
              }
            } receiveValue: { [weak self] in
                self?.receive(orderStatus: $0.executionReportStatus, orderResponse: $0)
            }.store(in: &cancellables)
    }

    func receive(orderStatus: OrderExecutionReportStatus, orderResponse: PostOrderResponse) {
        let executionReportStatus = orderResponse.executionReportStatus
        print("Response \(orderResponse.orderID): \(executionReportStatus)")
        switch executionReportStatus {
        case .executionReportStatusFill:
            receive(orderResponse: orderResponse)
        case .executionReportStatusCancelled, .executionReportStatusRejected:
            state = .pending
        case .executionReportStatusNew:
            if case State.postOrder = state {
                state = .orderCreated(orderResponse)
            } else if case State.stopOrder(let bounds, _) = state {
                state = .stopCreated(orderResponse, bounds)
            }
        case .executionReportStatusPartiallyfill:
            break
        case .UNRECOGNIZED, .executionReportStatusUnspecified:
            fatalError("⚠️ Unknown response status: \(executionReportStatus)")
        }
    }

    func getOrderStatus(response: PostOrderResponse, orderBook: OrderBook) {
        if ((response.direction == .buy
             && !orderBook.asks.isEmpty
             && orderBook.asks[0].price.asAmount >= response.initialSecurityPrice.asMoneyAmount.value)
            || (response.direction == .sell
                && !orderBook.bids.isEmpty
                && orderBook.bids[0].price.asAmount <= response.initialSecurityPrice.asMoneyAmount.value)) {
            getOrderStatus(id: response.orderID)
        }
    }

    func getOrderStatus(id: String) {
        interactor.getOrderState(accountID: config.accountID, orderID: id)
            .sink { result in
              switch result {
              case .failure(let error):
                  print(error)
              case .finished:
                  print("did finish getOrderState")
              }
            } receiveValue: { [weak self] in
                print("receiveValue getOrderState: \($0.executionReportStatus)")
                if let state = self?.state,
                   case State.orderCreated(let response) = state {
                    self?.receive(orderStatus: $0.executionReportStatus, orderResponse: response)
                }
            }.store(in: &cancellables)
    }

    func receive(orderResponse: PostOrderResponse) {

        let orderPrice = orderResponse.initialOrderPrice.asMoneyAmount.value

        switch state {
        case .postOrder:
            switch orderResponse.direction {
            case .buy:
                let tp = orderPrice * (1 + Decimal(config.takeProfitPercent) / 100)
                let sl = orderPrice * (1 - Decimal(config.stopLossPercent) / 100)
                let stopBounds = StopBounds(sl: sl, tp: tp)
                state = .orderPosted(orderResponse, stopBounds)
            case .sell:
                let sl = orderPrice * (1 + Decimal(config.stopLossPercent) / 100)
                let tp = orderPrice * (1 - Decimal(config.takeProfitPercent) / 100)
                let stopBounds = StopBounds(sl: sl, tp: tp)
                state = .orderPosted(orderResponse, stopBounds)
            default:
                state = .error
            }

        case .stopCreated:
            state = .pending

        case .pending, .orderPosted, .error, .orderCreated, .stopOrder, .stopped:
            print("⚠️ Invalid state")
            break
        }
    }

    func reloadData(orderBook: OrderBook) {
        let asks = mapOrders(orderBook.asks.reversed(), valueType: .ask)
        let bids = mapOrders(orderBook.bids, valueType: .bid)

        DispatchQueue.main.async { [weak self] in
            self?.reloadData(asks: asks, bids: bids)
        }
    }

    func mapOrders(_ orders: [Order], valueType: OrderBookCell.Model.ValueType) -> [OrderBookCell.Model] {
        return orders.map {
            let priceAmount = $0.price.asAmount
            let price = "\(priceAmount) \(config.currency.sign)"

            var type: OrderBookCell.Model.OrderType?
            if case State.orderPosted(let response, let stopBounds) = state {
                if priceAmount == response.initialOrderPrice.asMoneyAmount.value {
                    type = .order
                } else if priceAmount == stopBounds.tp {
                    type = .takeProfit
                } else if priceAmount == stopBounds.sl {
                    type = .stopLoss
                }
            } else if case State.stopOrder(let stopBounds, _) = state {
                if priceAmount == stopBounds.tp {
                    type = .takeProfit
                } else if priceAmount == stopBounds.sl {
                    type = .stopLoss
                }
            }

            return OrderBookCell.Model(price: price, value: "\($0.quantity)", valueType: valueType, orderType: type)
        }
    }

    func reloadData(asks: [OrderBookCell.Model], bids: [OrderBookCell.Model]) {
        self.asks = asks
        self.bids = bids
        viewController?.reloadData()
    }

    func cancelOrders() {
        #warning("todo")
    }
}

extension OrderBookPresenter: IOrderBookPresenter {

    func rows(in section: OrderBookPresenter.Section) -> [OrderBookCell.Model] {
        switch section {
        case .ask: return asks
        case .bid: return bids
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        
    }

    func setState(running: Bool) {
        state = running ? .pending : .stopped
    }
}
