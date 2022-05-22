//
//  OrderBooksDemoDto.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 22.05.2022.
//

import Foundation

struct OrderBooksDemoDto: Decodable {
    let interval: Double
    let data: [OrderBookDemoDto]
}
