//
//  DealEntity.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 20.05.2022.
//

import Foundation
import CoreData

extension DealEntity {

    convenience init(deal: Deal, context: NSManagedObjectContext) {
        self.init(context: context)
        self.robotId = deal.robotId
        self.open = DealOrderEntity(order: deal.open, context: context)
        self.close = DealOrderEntity(order: deal.close, context: context)
        self.currency = deal.currency
        self.quantity = deal.quantity
        self.stopLoss = deal.stopLoss as NSDecimalNumber
        self.takeProfit = deal.takeProfit as NSDecimalNumber
    }
}
