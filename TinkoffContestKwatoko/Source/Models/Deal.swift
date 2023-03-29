//
//  Deal.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 19.05.2022.
//

import Foundation

// MARK: Сделка

/// Каждая сделка состоит из двух заявок:
/// - открытие сделки
/// - закрытие сделки
/// Заработок (убыток) от сделки формируется из разницы цен заявки закрытия и заявки открытия

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
                case .buy: return L10n.Localization.directionBuy
                case .sell: return L10n.Localization.directionSell
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
    let quantity: Int64
    let stopLoss: Decimal
    let takeProfit: Decimal
}

extension Deal {

    var profitPriceValue: Decimal {
        guard let close = close else {
            return self.open.closed == nil ? 0 : -self.open.price
        }
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

// MARK: Entity initializers

extension Deal {

    init?(_ entity: DealEntity) {
        guard let robotId = entity.robotId,
              let open = Order(entity.open),
              let currency = entity.currency,
              let stopLoss = entity.stopLoss,
              let takeProfit = entity.takeProfit
        else { return nil }
        self.robotId = robotId
        self.open = open
        self.close = Order(entity.close)
        self.currency = currency
        self.quantity = entity.quantity
        self.stopLoss = stopLoss as Decimal
        self.takeProfit = takeProfit as Decimal
    }
}

extension Deal.Order {

    init?(_ entity: DealOrderEntity?) {
        guard let entity = entity,
              let id = entity.id,
              let opened = Book(entity.opened),
              let direction = Direction(rawValue: Int(entity.direction)),
              let price = entity.price
        else { return nil }
        self.id = id
        self.opened = opened
        self.closed = Book(entity.closed)
        self.direction = direction
        self.price = price as Decimal
    }
}

extension Deal.Order.Book {

    init?(_ entity: DealOrderBookEntity?) {
        guard let date = entity?.date else { return nil }
        self.date = date
        self.asks = ((entity?.asks as? Set<BookOrderEntity>)?
            .compactMap { .init($0) } ?? [])
            .sorted(by: { $1.price < $0.price })
        self.bids = ((entity?.bids as? Set<BookOrderEntity>)?
            .compactMap { .init($0) } ?? [])
            .sorted(by: { $1.price < $0.price })
    }
}

extension Deal.Order.Book.Order {

    init?(_ entity: BookOrderEntity) {
        guard let price = entity.price else { return nil }
        self.price = price as Decimal
        self.quantity = entity.quantity
    }
}
