//
//  BookOrderEntity.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 20.05.2022.
//

import Foundation
import CoreData

extension BookOrderEntity {

    convenience init(order: Deal.Order.Book.Order, context: NSManagedObjectContext) {
        self.init(context: context)
        self.price = order.price as NSDecimalNumber
        self.quantity = order.quantity
    }
}
