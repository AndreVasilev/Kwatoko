//
//  HistoryItem.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 16.05.2022.
//

import Foundation
import TinkoffInvestSDK

struct HistoryItem {
    let orderDto: PostOrderDto
    let orderBook: OrderBook?
}
