//
//  DealOrderEntity.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 20.05.2022.
//

import Foundation
import CoreData

extension DealOrderEntity {

    convenience init?(order: Deal.Order?, context: NSManagedObjectContext) {
        guard let o = order else { return nil }
        self.init(order: o, context: context)
    }

    convenience init(order: Deal.Order, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = order.id
        self.opened = DealOrderBookEntity(book: order.opened, context: context)
        self.closed = DealOrderBookEntity(book: order.closed, context: context)
        self.direction = Int16(order.direction.rawValue)
        self.price = order.price as NSDecimalNumber
    }
}
