//
//  OrderBookPresenter.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import Combine
import TinkoffInvestSDK
import CombineGRPC

final class OrderBookPresenter: BasePresenter {

    enum Section {
        case ask, bid
    }

    struct RowModel {

        enum OrderType {
            case order, stopLoss, takeProfit

            var description: String {
                switch self {
                case .order: return "заявка"
                case .stopLoss: return "стоп-лосс"
                case .takeProfit: return "тейк-профит"
                }
            }
        }

        let price: Decimal
        let quantity: Int64
        let section: Section
        let orderType: OrderType?
        let currencySign: String

        init(_ section: Section, price: Decimal, currencySign: String, quantity: Int64, orderType: OrderType? = nil) {
            self.price = price
            self.quantity = quantity
            self.orderType = orderType
            self.currencySign = currencySign
            self.section = section
        }

        var priceString: String { "\(price) \(currencySign)" }
        var quantityString: String { "\(quantity)" }
    }

    let interactor: IOrderBookInteractor
    let router: IOrderBookRouter
    weak var viewController: IOrderBookView?

    let strategy: IOrderBookStrategy
    
    var cancellables = Set<AnyCancellable>()

    // DataSource

    let sections = [Section.ask, .bid]
    var bids = [RowModel]()
    var asks = [RowModel]()

    init(interactor: IOrderBookInteractor, router: IOrderBookRouter, strategy: IOrderBookStrategy) {
        self.interactor = interactor
        self.router = router
        self.strategy = strategy
        super.init(router: router)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToOrderBook()
    }
}

private extension OrderBookPresenter {

    func subscribeToOrderBook() {
        interactor.subscribeToOrderBook(figi: strategy.instrument.figi, depth: strategy.depth)
            .sink { [weak self] in
              switch $0 {
              case .failure(let error):
                  self?.handleError(error)
              case .finished:
                  print("did finish loading marketDataServiceStream")
              }
            } receiveValue: { [weak self] in
                self?.receive(orderBook: $0)
            }.store(in: &cancellables)
    }

    func receive(orderBook: OrderBook) {
        
        strategy.receive(orderBook: orderBook)
        let sign = MoneyCurrency(rawValue: strategy.instrument.currency)?.sign ?? ""

        var asks = orderBook.asks
            .reversed()
            .map {
                return RowModel(.ask, price: $0.price.asAmount, currencySign: sign, quantity: $0.quantity)
            }

        var bids = orderBook.bids
            .map {
                return RowModel(.bid, price: $0.price.asAmount, currencySign: sign, quantity: $0.quantity)
            }

        let orders: [(PreOrderModel, RowModel.OrderType)] = [(strategy.order, RowModel.OrderType.order),
                                                             (strategy.stopLoss, RowModel.OrderType.stopLoss),
                                                             (strategy.takeProfit, RowModel.OrderType.takeProfit)]
            .compactMap { $0.0 != nil ? ($0.0!, $0.1) : nil }
        orders.forEach {
            let model = RowModel($0.0.section, price: $0.0.price, currencySign: sign, quantity: $0.0.quantity, orderType: $0.1)
            switch $0.0.section {
            case .bid: bids.append(model)
            case .ask: asks.append(model)
            }
        }

        asks.sort(by: { $1.price < $0.price })
        bids.sort(by: { $1.price < $0.price })

        DispatchQueue.main.async { [weak self] in
            self?.reloadData(asks: asks, bids: bids)
        }
    }

    func reloadData(asks: [RowModel], bids: [RowModel]) {
        self.asks = asks
        self.bids = bids
        viewController?.reloadData()
    }
}

extension OrderBookPresenter: IOrderBookPresenter {

    var isRunning: Bool { strategy.isRunning }

    func rows(in section: OrderBookPresenter.Section) -> [RowModel] {
        switch section {
        case .ask: return asks
        case .bid: return bids
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        
    }

    func setState(running: Bool) {
        running ? strategy.run() : strategy.stop()
    }
}
