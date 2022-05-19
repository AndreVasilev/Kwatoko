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

    let sdk: TinkoffInvestSDK
    let database: IDatabaseService
    let robot: Robot
    
    var cancellables = Set<AnyCancellable>()

    var order: PreOrderModel?
    var stopLoss: PreOrderModel?
    var takeProfit: PreOrderModel?

    init(sdk: TinkoffInvestSDK, database: IDatabaseService, robot: Robot) {
        self.sdk = sdk
        self.database = database
        self.robot = robot
    }

    // Legacy State

    var history = [Trade]()

    private enum State {
        case stopped
        case pending
        case postOrder(OrderBook)
        case orderCreated(PostOrderResponse)
        case orderPosted(PostOrderResponse, StopBounds)
        case stopOrder(StopBounds, OrderBook)
        case stopCreated(PostOrderResponse, StopBounds)
        case error
    }

    private var trade: Trade?

    private var state: State = .stopped {
        didSet {
            switch state {
            case .stopped:
                cancelOrders()
                if let trade = self.trade {
                    storeHistory(trade: trade)
                    self.trade = nil
                }
            case .pending:
                if let trade = self.trade {
                    storeHistory(trade: trade)
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

}

// MARK: Private

private extension ContestStrategy {

    var config: ContestStrategy.Config {
        robot.config as! ContestStrategy.Config
    }
}

// MARK: IStrategy

extension ContestStrategy: IStrategy {

    var figi: String { config.figi }
    var currency: MoneyCurrency { config.currency }

    func run() {
        state = .pending
    }

    func stop() {
        state = .stopped
    }
}

// MARK: IOrderBookStrategy

extension ContestStrategy: IOrderBookStrategy {

    var depth: Int { config.depth }

    func receive(orderBook: OrderBook) {
        legacy_receive(orderBook: orderBook)
    }
}

// MARK: Legacy

private extension ContestStrategy {

    typealias StopBounds = Trade.StopBounds
    typealias Model = ContestStrategy.Config

    struct RequestData {
        let price: Decimal
        let direction: OrderDirection
        let stopLoss: Decimal
        let takeProfit: Decimal
    }

    func legacy_receive(orderBook: OrderBook) {

        if orderBook.asks.count > 5,
           orderBook.bids.count > 5 {
            order = PreOrderModel(price: orderBook.asks[3].price.asAmount, quantity: orderBook.asks[3].quantity, section: .ask)
            stopLoss = PreOrderModel(price: orderBook.asks[5].price.asAmount, quantity: orderBook.asks[5].quantity, section: .ask)
            takeProfit = PreOrderModel(price: orderBook.bids[4].price.asAmount, quantity: orderBook.bids[4].quantity, section: .bid)
        }

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

        postOrder(request: request)
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
        getOrderState(accountID: config.accountID, orderID: id)
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

    func cancelOrders() {
        #warning("todo")
    }
}

// MARK: Interactor

private extension ContestStrategy {

    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError> {
        return sdk.sandboxService.postOrder(request: request)
    }

    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError> {
        return sdk.sandboxService.getOrderState(accountID: accountID, orderID: orderID)
    }

    func storeHistory(trade: Trade) {
        history.append(trade)
    }
}
