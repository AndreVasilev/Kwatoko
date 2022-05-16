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

    enum Section {
        case ask, bid
    }

    struct Model {
        let accountID: String
        let figi: String
        let depth: Int
        let currency: MoneyCurrency

        let orderDirection: OrderDirection

        let edgeQuantity: Int64
        let orderQuantity: Int64
        let orderDelta: Decimal
        let stopLossPercent: Double
        let takeProfitPercent: Double
    }

    struct RequestData {
        let price: Decimal
        let direction: OrderDirection
        let stopLoss: Decimal
        let takeProfit: Decimal
    }

    struct StopBounds {
        let sl: Decimal
        let tp: Decimal
    }

    let interactor: IOrderBookInteractor
    let router: IOrderBookRouter
    weak var viewController: IOrderBookView?
    let model: Model
    
    var cancellables = Set<AnyCancellable>()

    // DataSource

    let sections = [Section.ask, .bid]
    var bids = [OrderBookCell.Model]()
    var asks = [OrderBookCell.Model]()
    var orderBook: OrderBook?

    // State

    enum State {
        case pending
        case postOrder
        case orderCreated(PostOrderResponse)
        case orderPosted(PostOrderResponse, StopBounds)
        case stopOrder(StopBounds)
        case stopCreated(PostOrderResponse, StopBounds)
        case error
    }

    var state: State = .pending

    init(interactor: IOrderBookInteractor, router: IOrderBookRouter, model: Model) {
        self.interactor = interactor
        self.router = router
        self.model = model
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToOrderBook()
    }
}

private extension OrderBookPresenter {

    func subscribeToOrderBook() {
        interactor.subscribeToOrderBook(figi: model.figi, depth: model.depth)
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
                state = .postOrder
                postOrder(price: tuple.price, direction: tuple.direction)
            }

        case .orderPosted(let response, let stopBounds):
            if let tuple = getRequestData(orderBook: orderBook,
                                          orderResponse: response,
                                          stopBounds: stopBounds) {
                state = .stopOrder(stopBounds)
                postOrder(price: tuple.price, direction: tuple.direction)
            }

        case .orderCreated(let response):
            getOrderStatus(response: response, orderBook: orderBook)

        case .stopCreated(let response, _):
            getOrderStatus(response: response, orderBook: orderBook)

        case .postOrder, .stopOrder, .error:
            break
        }

        reloadData(orderBook: orderBook)
    }

    func getRequestData(from orderBook: OrderBook) -> (price: Decimal, direction: OrderDirection)? {
        if model.orderDirection != .sell,
           let bid = orderBook.bids.first(where: { $0.quantity >= model.edgeQuantity }) {
            return ((bid.price.asAmount + model.orderDelta), .buy)
        } else if model.orderDirection != .buy,
           let ask = orderBook.asks.first(where: { $0.quantity >= model.edgeQuantity }) {
            return ((ask.price.asAmount - model.orderDelta), .sell)
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
        request.quantity = model.orderQuantity
        request.orderType = .limit
        request.figi = model.figi
        request.accountID = model.accountID

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
            } else if case State.stopOrder(let bounds) = state {
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
        interactor.getOrderState(accountID: model.accountID, orderID: id)
            .sink { result in
              switch result {
              case .failure(let error):
                  print(error)
              case .finished:
                  print("did finish getOrderState")
              }
            } receiveValue: { [weak self] in
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
                let tp = orderPrice * (1 + Decimal(model.takeProfitPercent) / 100)
                let sl = orderPrice * (1 - Decimal(model.stopLossPercent) / 100)
                let stopBounds = StopBounds(sl: sl, tp: tp)
                state = .orderPosted(orderResponse, stopBounds)
                interactor.storeHistory(response: orderResponse, description: "PostOrder", orderBook: orderBook)
            case .sell:
                let sl = orderPrice * (1 + Decimal(model.stopLossPercent) / 100)
                let tp = orderPrice * (1 - Decimal(model.takeProfitPercent) / 100)
                let stopBounds = StopBounds(sl: sl, tp: tp)
                state = .orderPosted(orderResponse, stopBounds)
                interactor.storeHistory(response: orderResponse, description: "PostOrder", orderBook: orderBook)
            default:
                state = .error
            }

        case .stopCreated:
            state = .pending
            interactor.storeHistory(response: orderResponse, description: "StopOrder", orderBook: orderBook)

        case .pending, .orderPosted, .error, .orderCreated, .stopOrder:
            print("⚠️ Invalid state")
            break
        }
    }

    func reloadData(orderBook: OrderBook) {
        let asks = mapOrders(orderBook.asks.reversed(), valueType: .ask)
        let bids = mapOrders(orderBook.bids, valueType: .bid)

        DispatchQueue.main.async { [weak self] in
            self?.reloadData(asks: asks, bids: bids, orderBook: orderBook)
        }
    }

    func mapOrders(_ orders: [Order], valueType: OrderBookCell.Model.ValueType) -> [OrderBookCell.Model] {
        return orders.map {
            let priceAmount = $0.price.asAmount
            let price = "\(priceAmount) \(model.currency.sign)"

            var type: OrderBookCell.Model.OrderType?
            if case State.orderPosted(let response, let stopBounds) = state {
                if priceAmount == response.initialOrderPrice.asMoneyAmount.value {
                    type = .order
                } else if priceAmount == stopBounds.tp {
                    type = .takeProfit
                } else if priceAmount == stopBounds.sl {
                    type = .stopLoss
                }
            } else if case State.stopOrder(let stopBounds) = state {
                if priceAmount == stopBounds.tp {
                    type = .takeProfit
                } else if priceAmount == stopBounds.sl {
                    type = .stopLoss
                }
            }

            return OrderBookCell.Model(price: price, value: "\($0.quantity)", valueType: valueType, orderType: type)
        }
    }

    func reloadData(asks: [OrderBookCell.Model], bids: [OrderBookCell.Model], orderBook: OrderBook) {
        self.asks = asks
        self.bids = bids
        self.orderBook = orderBook
        viewController?.reloadData()
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
}
