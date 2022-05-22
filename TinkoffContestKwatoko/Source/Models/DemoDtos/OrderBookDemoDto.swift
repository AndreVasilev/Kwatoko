//
//  OrderBookDemoDto.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 22.05.2022.
//

import Foundation

struct OrderBookDemoDto: Decodable {
    let asks: [OrderDemoDto]
    let bids: [OrderDemoDto]
}
