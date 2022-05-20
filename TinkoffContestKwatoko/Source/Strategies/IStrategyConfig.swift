//
//  IStrategyConfig.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import Foundation
import TinkoffInvestSDK

protocol IStrategyConfig {

    var id: String { get }
    var instrument: IInstrument { get }
}

struct Instrument: IInstrument {

    let figi: String
    let currency: String
    let name: String
    let ticker: String

    init?(_ entity: InstrumentEntity?) {
        guard let figi = entity?.figi,
              let currency = entity?.currency,
              let name = entity?.name,
              let ticker = entity?.ticker
        else { return nil }
        self.figi = figi
        self.currency = currency
        self.name = name
        self.ticker = ticker
    }

    init(figi: String, currency: String, name: String, ticker: String) {
        self.figi = figi
        self.currency = currency
        self.name = name
        self.ticker = ticker
    }
}
