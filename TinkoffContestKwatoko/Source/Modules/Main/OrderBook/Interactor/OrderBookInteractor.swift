//
//  OrderBookInteractor.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK

final class OrderBookInteractor {

    let sdk: TinkoffInvestSDK

    init(sdk: TinkoffInvestSDK) {
        self.sdk = sdk
   }
}

extension OrderBookInteractor: IOrderBookInteractor {

    func subscribeToOrderBook(figi: String, depth: Int) -> MarketDataPublisher {
        return sdk.marketDataServiceStream.subscribeToOrderBook(figi: figi, depth: depth)
    }
}
