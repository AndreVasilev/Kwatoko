//
//  Trade.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 17.05.2022.
//

import Foundation
import TinkoffInvestSDK

struct Trade {

    struct Order {
        let orderBook: OrderBook
        var response: PostOrderResponse?
        let date: Date
    }

    struct StopBounds {
        let sl: Decimal
        let tp: Decimal
    }

    var open: Order
    var stopBounds: StopBounds?
    var close: Order?
    var error: Error?
}
