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

fileprivate typealias PostedOrderData = (response: PostOrderResponse, direction: OrderDirection, orderBook: OrderBook)

class ContestStrategy {

    private let ordersService: OrdersService
    private let database: IDatabaseService
    private let robot: Robot
    weak var delegate: IStrategyDelegate?
    
    private var cancellables = Set<AnyCancellable>()

    private var deal: Deal?
    private var preDealOrder: Deal.Order?

    private let dateFormatter = DateFormatter("HH:mm:ss.SSS")
    private let reopenOffsetLimit = 4
    private let reopenDistanceLimit = 2

    init(ordersService: OrdersService, database: IDatabaseService, robot: Robot) {
        self.ordersService = ordersService
        self.database = database
        self.robot = robot
    }

    // State
    
    private enum State {
        /// Робот остановлен
        case stopped
        /// Робот запущен и находится в поисках аномальной заявки
        case pending
        /// Отправлен запрос на выставление заявки для открытия сделки
        case preOpenOrderPosted
        /// Выставлена заявка для открытия сделки
        case openOrderPosted(PostedOrderData)
        /// Исполнена заявка для открытия сделки
        case openOrderExecuted
        /// Отправлен запрос на выставление заявки для закрытие сделки
        case preCloseOrderPosted
        /// Выставлена заявка для закрытия сделки
        case closeOrderPosted(PostedOrderData)
        /// Произошла ошибка в критичный для работы алгоритма момент
        case error(String)

        var name: String {
            switch self {
            case .stopped: return "stopped"
            case .pending: return "pending"
            case .preOpenOrderPosted: return "preOpenOrderPosted"
            case .openOrderPosted: return "openOrderPosted"
            case .openOrderExecuted: return "openOrderExecuted"
            case .preCloseOrderPosted: return "preCloseOrderPosted"
            case .closeOrderPosted: return "closeOrderPosted"
            case .error: return "error"
            }
        }
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
            case .openOrderPosted(let data):
                preDealOrder = Deal.Order.open(data: data)
            case .closeOrderPosted(let data):
                preDealOrder = Deal.Order.open(data: data)
            case .error(let message):
                delegate?.didReceiveError(message)
            }
        }
    }
}

// MARK: IStrategy

extension ContestStrategy: IStrategy {

    var instrument: IInstrument { config.instrument }

    var isRunning: Bool {
        if case State.stopped = state {
            return false
        } else {
            return true
        }
    }

    // Запуск робота

    func run() {
        guard !isRunning else { return }
        state = .pending
    }

    // Остановка робота

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

    // Обработка получения данных стакана в зависимости от текущего состояния

    private func receive(orderBook: OrderBook, state: State) {
        log("Received: orderBook")

        switch state {
        case .pending:
            pending(orderBook)
        case .openOrderPosted(let data):
            checkOpenOrderStatus(data: data, receivedOrderBook: orderBook)
        case .openOrderExecuted:
            checkClose(orderBook)
        case .closeOrderPosted(let data):
            checkOrderStatus(order: preDealOrder, id: data.response.orderID, orderBook) { [weak self] in
                self?.closeDeal(order: $0.order,
                                orderID: $0.state.orderID,
                                direction: data.direction,
                                price: $0.state.initialSecurityPrice.asMoneyAmount.value,
                                orderBook: orderBook)
            }

        case .stopped, .error, .preOpenOrderPosted, .preCloseOrderPosted:
            return
        }
    }

    // Обработка получения данных стакана в состоянии .pending

    func pending(_ orderBook: OrderBook) {
        
        guard let tuple = getOpenOrderData(orderBook: orderBook) else { return }

        // Если была найдена аномальная заявка, выставляется соответсвующий ордер

        postOpenOrder(tuple, orderBook: orderBook)
    }
    
    func checkOpenOrderStatus(data: PostedOrderData, receivedOrderBook orderBook: OrderBook) {
        guard let order = preDealOrder else {
            log("CheckOpenOrderStatus: missing order")
            return
        }
        
        let isStateRequested = checkOrderStatus(order: order, id: data.response.orderID, orderBook) { [weak self] in
            self?.openDeal(order: $0.order,
                           orderID: $0.state.orderID,
                           direction: data.direction,
                           price: $0.state.initialSecurityPrice.asMoneyAmount.value,
                           orderBook: orderBook)
        }
        
        // Пока заявка не исполнилась проверяем в стакане наличие аномальных заявок ближе к центру

        guard !isStateRequested,
              let tuple = getOpenOrderData(orderBook: orderBook)
        else { return }

        var offset: Int?
        switch data.direction {
        case .buy: offset = orderBook.bids.firstIndex(where: { $0.price.asAmount <= order.price })
        case .sell: offset = orderBook.asks.firstIndex(where: { $0.price.asAmount >= order.price })
        case .unspecified, .UNRECOGNIZED(_): return
        }
        
        guard offset == nil
                || (offset! > reopenOffsetLimit
                    && tuple.offset < offset!
                    && (offset! - tuple.offset > reopenDistanceLimit))
        else { return }
        
        // Если обнаружилась более актуальная аномальная заявка - отменяет старый ордер и выставляем новый

        cancelOrder(order: order)
        postOpenOrder(tuple, orderBook: orderBook)
    }

    // Проверка актуального статуса выставленной заявки

    typealias CheckOrderStatus = (order: Deal.Order, state: OrderState)
    
    func checkOrderStatus(order: Deal.Order?, id: String,
                          _ orderBook: OrderBook,
                          _ onFillCompletion: @escaping (CheckOrderStatus) -> Void) -> Bool {
        guard let order = order else {
            log("CheckOrderStatus: missing order")
            return false
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

        guard requestCheck else { return false }
        log("CheckOrderStatus (\(id): \(orderBook.asks.first?.price.asAmount ?? 0) | \(orderBook.bids.first?.price.asAmount ?? 0)")

        getOrderState(accountID: config.accountID, orderID: id)
            .sink { [weak self] result in
              switch result {
              case .failure(let error):
                  self?.log("\(error)")
                  self?.presentErrorBanner(error)
              case .finished:
                  self?.log("GetOrderState finished")
              }
            } receiveValue: {
                if $0.executionReportStatus == .executionReportStatusFill {
                    onFillCompletion((order, $0))
                }
            }.store(in: &cancellables)
        
        return true
    }

    // Проверка данных стакана на необходимость выставить ордер по стоп-лоссу / тейк-профиту на закрытие сделки

    func checkClose(_ orderBook: OrderBook) {
        guard let deal = deal else {
            log("CheckClose: Missing deal")
            return
        }

        var tuple: (price: Decimal, direction: OrderDirection, success: Bool)?
        switch deal.open.direction {
        case .buy:
            if let ask = orderBook.asks.first,
               ask.price.asAmount >= deal.takeProfit {
                tuple = (ask.price.asAmount, .sell, success: true)
            } else if let bid = orderBook.bids.first,
                      bid.price.asAmount <= deal.stopLoss {
                tuple = (bid.price.asAmount, .sell, success: false)
            }
        case .sell:
            if let ask = orderBook.asks.first,
               ask.price.asAmount >= deal.stopLoss {
                tuple = (ask.price.asAmount, .buy, success: false)
            } else if let bid = orderBook.bids.first,
                      bid.price.asAmount <= deal.takeProfit {
                tuple = (bid.price.asAmount, .buy, success: true)
            }
        }

        // Если текущая актуальная цена попадает за границы стоп-лосса / тейк-профита, выставляется заявка на крытие сделки
        // Состояние переходит в следующее: .preOpenOrderPosted
        //
        // При получении статусов ордера .executionReportStatusNew или .executionReportStatusPartiallyfill
        // состояние переходит в следующее значение: .closeOrderPosted

        guard let tuple = tuple else { return }
        log("\(tuple.success ? "✅" : "⛔️") CheckClose \(tuple.direction == .buy ? "Buy" : "Sell"): \(tuple.price)")

        state = .preCloseOrderPosted
        postOrder(price: tuple.price, direction: tuple.direction) { [weak self] in
            self?.log("Response: \($0.executionReportStatus)")
            switch $0.executionReportStatus {
            case .executionReportStatusNew, .executionReportStatusPartiallyfill:
                self?.state = .closeOrderPosted(($0, tuple.direction, orderBook))
            case .executionReportStatusFill:
                self?.closeDeal(order: nil,
                                orderID: $0.orderID,
                                direction: tuple.direction,
                                price: $0.initialSecurityPrice.asMoneyAmount.value,
                                orderBook: orderBook)
            case .UNRECOGNIZED(_), .executionReportStatusCancelled, .executionReportStatusRejected, .executionReportStatusUnspecified:
                self?.log("Failed to post stop order: \($0.executionReportStatus)")
            }
        }
    }
}

// MARK: Interactor

private extension ContestStrategy {
    
    typealias OpenOrderData = (price: Decimal, direction: OrderDirection, order: Order, offset: Int)
    
    func getOpenOrderData(orderBook: OrderBook) -> OpenOrderData? {
        var tuples = [OpenOrderData]()
        
        if config.orderDirection != .sell,
           let item = orderBook.bids.enumerated().first(where: { $0.element.quantity >= config.edgeQuantity }) {
            let price = item.element.price.asAmount + config.orderDelta
            tuples.append((price, .buy, item.element, item.offset))
        }
        if config.orderDirection != .buy,
           let item = orderBook.asks.enumerated().first(where: { $0.element.quantity >= config.edgeQuantity }) {
            let price = item.element.price.asAmount - config.orderDelta
            tuples.append((price, .sell, item.element, item.offset))
        }
        
        let tuple = tuples.min(by: { $0.offset < $1.offset })
        return tuple
    }
    
    func postOpenOrder(_ tuple: OpenOrderData, orderBook: OrderBook) {
        // Состояние переходит в следующее: .preOpenOrderPosted
        //
        // При получении статусов ордера .executionReportStatusNew или .executionReportStatusPartiallyfill
        // состояние переходит в следующее значение: .openOrderPosted
        
        let sign = MoneyCurrency(rawValue: instrument.currency)?.sign ?? ""
        log("\(tuple.direction == .buy ? "Buy" : "Sell"): \(tuple.order.price.asAmount) \(sign) - \(tuple.order.quantity)")

        state = .preOpenOrderPosted
        postOrder(price: tuple.price, direction: tuple.direction) { [weak self] response in
            self?.log("Response: \(response.executionReportStatus)")
            switch response.executionReportStatus {
            case .executionReportStatusNew, .executionReportStatusPartiallyfill:
                self?.state = .openOrderPosted((response, tuple.direction, orderBook))
            case .executionReportStatusFill:
                self?.openDeal(order: nil,
                               orderID: response.orderID,
                               direction: tuple.direction,
                               price: response.initialSecurityPrice.asMoneyAmount.value,
                               orderBook: orderBook)
            case .UNRECOGNIZED(_), .executionReportStatusCancelled, .executionReportStatusRejected, .executionReportStatusUnspecified:
                self?.state = .pending
            }
        }
    }

    // Отправка запроса на выставление ордера

    func postOrder(price: Decimal, direction: OrderDirection, _ completion: @escaping (PostOrderResponse) -> Void) {
        var request = PostOrderRequest()
        request.price = price.asQuotation
        request.direction = direction
        request.quantity = config.orderQuantity
        request.orderType = .limit
        request.figi = config.instrument.figi
        request.accountID = config.accountID
        request.orderID = UUID().uuidString

        postOrder(request: request)
            .sink { [weak self] result in
              switch result {
              case .failure(let error):
                  self?.state = .error("\(error)")
                  self?.presentErrorBanner(error)
              case .finished:
                  self?.log("PostOrder finished")
              }
            } receiveValue: {
                completion($0)
            }.store(in: &cancellables)
    }

    // Открытие сделки
    // Состояние переходит в следующиее значение: .openOrderExecuted

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
                    currency: config.instrument.currency,
                    quantity: config.orderQuantity,
                    stopLoss: bounds.sl,
                    takeProfit: bounds.tp)
        preDealOrder = nil

        state = .openOrderExecuted
    }

    // Вычисление значений стоп-лосса и тейк-профита для открытой сделки в соответствии с конфигурацией робота

    func getStopBounds(orderPrice: Decimal, direction: OrderDirection) -> StopBounds? {
        let stopBounds: StopBounds?

        switch direction {
        case .buy:
            let tp = orderPrice * (1 + Decimal(config.takeProfitPercent / 100))
            let sl = orderPrice * (1 - Decimal(config.stopLossPercent / 100))
            stopBounds = StopBounds(sl: sl, tp: tp)
        case .sell:
            let sl = orderPrice * (1 + Decimal(config.stopLossPercent / 100))
            let tp = orderPrice * (1 - Decimal(config.takeProfitPercent / 100))
            stopBounds = StopBounds(sl: sl, tp: tp)
        default:
            stopBounds = nil
        }
        return stopBounds
    }

    // Закрытие сделки и сохранение истории
    // Состояние переходит в начальное значение: .pending

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

    // Отмена ордера

    func cancelOrder(order: Deal.Order?) {
        guard let order = order else { return }
        log("Cancel order: \(order.id)")
        cancelOrder(accountID: config.accountID, orderID: order.id)
            .sink { [weak self] result in
              switch result {
              case .failure(let error):
                  self?.log("\(error)")
                  self?.presentErrorBanner(error)
              case .finished:
                  self?.log("Order canceled")
              }
            } receiveValue: { [weak self] _ in
                self?.completeDealCancel(order: order)
            }.store(in: &cancellables)
    }

    // Сохранение сделки в историю при отмене ордера

    func completeDealCancel(order: Deal.Order) {
        let deal = Deal(robotId: robot.id,
                        open: self.deal?.open ?? order,
                        close: self.deal?.open != nil ? order : nil,
                        currency: config.instrument.currency,
                        quantity: config.orderQuantity,
                        stopLoss: self.deal?.stopLoss ?? 0,
                        takeProfit: self.deal?.takeProfit ?? 0)
        storeHistory(deal: deal)
    }
}

// MARK: SDK

extension ContestStrategy {

    func postOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError> {
        return ordersService.postOrder(request: request)
    }

    func cancelOrder(accountID: String, orderID: String) -> AnyPublisher<CancelOrderResponse, RPCError> {
        return ordersService.cancelOrder(accountID: accountID, orderID: orderID)
    }

    func getOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError> {
        return ordersService.getOrderState(accountID: accountID, orderID: orderID)
    }

    func storeHistory(deal: Deal) {
        DispatchQueue.main.async { [unowned self] in
            self.database.addDeal(deal)
        }
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
        print("🤖 \(dateFormatter.string(from: Date())) [\(state.name)] \(message)")
    }
    
    func presentErrorBanner(_ error: Error) {
        NotificationBanner.present(error)
    }
}

fileprivate extension Deal.Order {

    static func `open`(data: PostedOrderData) -> Deal.Order? {
        open(orderID: data.response.orderID,
             direction: data.direction,
             price: data.response.initialSecurityPrice.asMoneyAmount.value,
             orderBook: data.orderBook)
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

fileprivate extension Deal.Order.Book {

    init(_ orderBook: OrderBook) {
        self.init(asks: orderBook.asks.map { Order(price: $0.price.asAmount, quantity: $0.quantity) },
                  bids: orderBook.bids.map { Order(price: $0.price.asAmount, quantity: $0.quantity) },
                  date: orderBook.time.date)
    }
}

fileprivate extension Deal {

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
