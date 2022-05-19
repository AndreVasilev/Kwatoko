//
//  Deal.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 19.05.2022.
//

import Foundation

struct Deal {

    struct Order {

        struct Book {

            struct Order {
                let price: Decimal
                let quantity: Int64
            }

            let asks: [Order]
            let bids: [Order]
            let date: Date
        }

        enum Direction: Int16 {
            case buy, sell

            var title: String {
                switch self {
                case .buy: return "Покупка"
                case .sell: return "Продажа"
                }
            }
        }

        let opened: Book
        let closed: Book?
        let direction: Direction
        let price: Decimal
    }

    let robotId: String

    let open: Order
    let close: Order?

    let currency: String
    let quantity: Int
    let stopLoss: Decimal
    let takeProfit: Decimal
}

extension Deal {

    var profit: Decimal {
        guard let close = close else { return -100 }
        let delta: Decimal
        switch self.open.direction {
        case .buy: delta = close.price - self.open.price
        case .sell: delta = self.open.price - close.price
        }
        let profit = delta / self.open.price * 100
        return profit
    }

    var date: Date {
        return close?.date
            ?? self.open.date
    }
}

extension Deal.Order {

    var date: Date {
        return closed?.date
            ?? opened.date
    }
}
