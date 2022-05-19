//
//  IOrderBookInteractor.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK

protocol IOrderBookInteractor {

    func subscribeToOrderBook(figi: String, depth: Int) -> MarketDataPublisher
}
