//
//  ContestStrategy.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import Foundation
import TinkoffInvestSDK

class ContestStrategy {

    struct Config: IStrategyConfig {

        let id: String
        let accountID: String
        let figi: String
        let currency: MoneyCurrency

        let depth: Int
        let orderDirection: OrderDirection

        let edgeQuantity: Int64
        let orderQuantity: Int64
        let orderDelta: Decimal
        let stopLossPercent: Double
        let takeProfitPercent: Double

        init(id: String, accountID: String, figi: String, currency: MoneyCurrency, depth: Int, orderDirection: OrderDirection, edgeQuantity: Int64, orderQuantity: Int64, orderDelta: Decimal, stopLossPercent: Double, takeProfitPercent: Double) {
            self.id = id
            self.accountID = accountID
            self.figi = figi
            self.currency = currency
            self.depth = depth
            self.orderDirection = orderDirection
            self.edgeQuantity = edgeQuantity
            self.orderQuantity = orderQuantity
            self.orderDelta = orderDelta
            self.stopLossPercent = stopLossPercent
            self.takeProfitPercent = takeProfitPercent
        }

        init(id: String, accountID: String, figi: String, currency: MoneyCurrency) {
            self.id = id
            self.accountID = accountID
            self.figi = figi
            self.currency = currency
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
                  let figi = entity.figi,
                  let currencyValue = entity.currency,
                  let currency = MoneyCurrency(rawValue: currencyValue),
                  let orderDirection = OrderDirection(rawValue: Int(entity.orderDirection)),
                  let orderDelta = entity.orderDelta
            else { return nil }

            self.init(id: id,
                      accountID: accountID,
                      figi: figi,
                      currency: currency,
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

    var currencyValue: String { currency.rawValue }
}
