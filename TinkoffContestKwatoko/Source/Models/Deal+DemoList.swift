//
//  Deal+DemoList.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 19.05.2022.
//

import Foundation

extension Deal {

    static func demoList(robotId: String, currency: String, count: Int = 10) -> [Deal] {
        return Array(0 ..< count)
            .map { _ in
                let direction: Order.Direction = arc4random() % 2 == 0 ? .sell : .buy
                let openPrice = Decimal(arc4random() % 10 + 100)
                let profit = Decimal(arc4random() % 3) + Decimal(arc4random() % 100) / 100
                return buildDeal(robotId: robotId, currency: currency, direction: direction, openPrice: openPrice, profit: profit)
            }
    }

    static private func buildDeal(robotId: String, currency: String, direction: Order.Direction, openPrice: Decimal, profit: Decimal, quantiy: Int = 10) -> Deal {
        let stopLoss: Decimal
        let takeProfit: Decimal
        let closeDirection: Order.Direction
        switch direction {
        case .sell:
            closeDirection = .buy
            stopLoss = openPrice * 1.1
            takeProfit = openPrice * 0.95
        case .buy:
            closeDirection = .sell
            stopLoss = openPrice * 0.99
            takeProfit = openPrice * 1.05
        }
        let closePrice = (1 + profit / 100) * openPrice

        return Deal(robotId: robotId,
                    open: buildOrder(direction: direction, price: openPrice),
                    close: buildOrder(direction: closeDirection, price: closePrice),
                    currency: currency,
                    quantity: quantiy,
                    stopLoss: stopLoss,
                    takeProfit: takeProfit)
    }

    static private func buildOrder(direction: Order.Direction, price: Decimal, depth: Int = 10, step: Decimal = 1) -> Order {

        let anomalyIndex = depth / 2
        var openAnomalyIndex: Int?
        switch direction {
        case .buy: openAnomalyIndex = depth - anomalyIndex
        case .sell: openAnomalyIndex = depth + anomalyIndex
        }
        let openMiddlePriceDelta = Decimal(anomalyIndex) * step
        let openMiddlePrice = direction == .sell ? price - openMiddlePriceDelta : price + openMiddlePriceDelta

        return Order(opened: buildBook(middlePrice: openMiddlePrice, depth: depth, step: step, anomalyIndex: openAnomalyIndex),
                     closed: buildBook(middlePrice: price, depth: depth, step: step, anomalyIndex: nil),
                     direction: direction,
                     price: price)
    }

    static func buildBook(middlePrice: Decimal, depth: Int, step: Decimal, anomalyIndex: Int?) -> Order.Book {
        var askAnomalyIndex: Int?
        var bidAnomalyIndex: Int?
        if let index = anomalyIndex {
            askAnomalyIndex = index > depth ? index - depth : nil
            bidAnomalyIndex = index < depth ? index : nil
        }
        return Order.Book(asks: buildBookOrders(fromPrice: middlePrice + 0.5, step: step, count: depth, anomalyIndex: askAnomalyIndex),
                          bids: buildBookOrders(fromPrice: middlePrice - 0.5, step: step, count: depth, anomalyIndex: bidAnomalyIndex),
                          date: Date())
    }

    static func buildBookOrders(fromPrice: Decimal, step: Decimal, count: Int, anomalyIndex: Int?) -> [Order.Book.Order] {
        return Array(0 ..< count)
            .enumerated()
            .map {
                let price = fromPrice + step * Decimal($0.offset)
                var quantity = Int64(arc4random() % 300)
                if $0.offset == anomalyIndex {
                    quantity *= 10000
                }
                return Order.Book.Order(price: price, quantity: quantity)
            }
    }
}
