//
//  IStrategy.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 19.05.2022.
//

import Foundation
import TinkoffInvestSDK

protocol IStrategy {

    var figi: String { get }
    var currency: MoneyCurrency { get }

    func run()
    func stop()
}

protocol IOrderBookStrategy: IStrategy {

    var depth: Int { get }

    var order: PreOrderModel? { get }
    var stopLoss: PreOrderModel? { get }
    var takeProfit: PreOrderModel? { get }

    func receive(orderBook: OrderBook)
}

struct PreOrderModel {

    let price: Decimal
    let quantity: Int64
    let section: OrderBookPresenter.Section
}
