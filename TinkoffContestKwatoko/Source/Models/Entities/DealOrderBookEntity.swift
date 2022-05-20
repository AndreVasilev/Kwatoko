//
//  DealOrderBookEntity.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 20.05.2022.
//

import Foundation
import CoreData

extension DealOrderBookEntity {

    convenience init?(book: Deal.Order.Book?, context: NSManagedObjectContext) {
        guard let b = book else { return nil }
        self.init(book: b, context: context)
    }

    convenience init(book: Deal.Order.Book, context: NSManagedObjectContext) {
        self.init(context: context)
        self.date = book.date
        self.asks = NSSet(array: book.asks.map { BookOrderEntity(order: $0, context: context) })
        self.bids = NSSet(array: book.bids.map { BookOrderEntity(order: $0, context: context) })
    }
}
