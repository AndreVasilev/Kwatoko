//
//  ContestStrategyConfig.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 19.05.2022.
//

import Foundation
import TinkoffInvestSDK

extension ContestStrategy {

    struct Config: IStrategyConfig {

        let id: String
        let accountID: String
        let instrument: IInstrument

        let depth: Int
        let orderDirection: OrderDirection

        let edgeQuantity: Int64
        let orderQuantity: Int64
        let orderDelta: Decimal
        let stopLossPercent: Double
        let takeProfitPercent: Double

        init(id: String, accountID: String, instrument: IInstrument, depth: Int, orderDirection: OrderDirection, edgeQuantity: Int64, orderQuantity: Int64, orderDelta: Decimal, stopLossPercent: Double, takeProfitPercent: Double) {
            self.id = id
            self.accountID = accountID
            self.instrument = instrument
            self.depth = depth
            self.orderDirection = orderDirection
            self.edgeQuantity = edgeQuantity
            self.orderQuantity = orderQuantity
            self.orderDelta = orderDelta
            self.stopLossPercent = stopLossPercent
            self.takeProfitPercent = takeProfitPercent
        }

        init(id: String, accountID: String, instrument: IInstrument) {
            self.id = id
            self.accountID = accountID
            self.instrument = Instrument(figi: instrument.figi,
                                         currency: instrument.currency,
                                         name: instrument.name,
                                         ticker: instrument.ticker)
            self.depth = 20
            self.orderDirection = .unspecified
            self.edgeQuantity = 5000
            self.orderQuantity = 1
            self.orderDelta = 0.1
            self.stopLossPercent = 0.1
            self.takeProfitPercent = 0.5
        }

        init?(_ entity: ContestStrategyConfigEntity) {
            guard let id = entity.id,
                  let accountID = entity.accountID,
                  let instrument = Instrument(entity.instrument),
                  let orderDirection = OrderDirection(rawValue: Int(entity.orderDirection)),
                  let orderDelta = entity.orderDelta
            else { return nil }
            self.init(id: id,
                      accountID: accountID,
                      instrument: instrument,
                      depth: Int(entity.depth),
                      orderDirection: orderDirection,
                      edgeQuantity: entity.edgeQuantity,
                      orderQuantity: entity.orderQuantity,
                      orderDelta: orderDelta.decimalValue,
                      stopLossPercent: entity.stopLossPercent,
                      takeProfitPercent: entity.takeProfitPercent)
        }
    }
}

extension ContestStrategy.Config {

    var currencyValue: String { instrument.currency }
}
