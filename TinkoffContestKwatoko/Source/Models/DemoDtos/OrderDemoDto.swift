//
//  OrderDemoDto.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 22.05.2022.
//

import Foundation

struct OrderDemoDto: Decodable {
    let quantity: Int64
    let price: Decimal
}
