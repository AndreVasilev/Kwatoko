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

        enum Direction: Int {
            case buy = 1
            case sell = 2

            var title: String {
                switch self {
                case .buy: return "Покупка"
                case .sell: return "Продажа"
                }
            }
        }

        let id: String
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

    var profitPriceValue: Decimal {
        guard let close = close else { return -self.open.price }
        let value: Decimal
        switch self.open.direction {
        case .buy: value = close.price - self.open.price
        case .sell: value = self.open.price - close.price
        }
        return value
    }

    var profit: Decimal {
        return profitPriceValue / self.open.price * 100
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
