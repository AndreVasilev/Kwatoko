//
//  ContestStrategyConfigEntity.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 20.05.2022.
//

import Foundation
import CoreData

extension ContestStrategyConfigEntity {

    convenience init(config: ContestStrategy.Config, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = config.id
        self.accountID = config.accountID
        self.instrument = InstrumentEntity(instrument: config.instrument, context: context)
        self.depth = Int16(config.depth)
        self.orderDirection = Int16(config.orderDirection.rawValue)
        self.edgeQuantity = config.edgeQuantity
        self.orderQuantity = config.orderQuantity
        self.orderDelta = NSDecimalNumber(decimal: config.orderDelta)
        self.stopLossPercent = config.stopLossPercent
        self.takeProfitPercent = config.takeProfitPercent
    }
}
