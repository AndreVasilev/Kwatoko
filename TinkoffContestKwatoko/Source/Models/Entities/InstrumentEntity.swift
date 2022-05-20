//
//  InstrumentEntity.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 20.05.2022.
//

import Foundation
import CoreData

extension InstrumentEntity {

    convenience init(instrument: IInstrument, context: NSManagedObjectContext) {
        self.init(context: context)
        self.figi = instrument.figi
        self.currency = instrument.currency
        self.name = instrument.name
        self.ticker = instrument.ticker
    }
}
