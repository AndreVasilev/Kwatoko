//
//  IStrategyConfig.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import Foundation

protocol IStrategyConfig {

    var id: String { get }
    var figi: String { get }
    var currencyValue: String { get }
}
