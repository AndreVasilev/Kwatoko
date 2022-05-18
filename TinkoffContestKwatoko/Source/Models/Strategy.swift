//
//  Strategy.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import Foundation

enum Strategy: String, CaseIterable {

    case contest
}

extension Strategy {

    enum Kind {
        case orderBook
    }

    var name: String {
        switch self {
        case .contest: return "Торговля по стакану"
        }
    }

    var kind: Kind {
        switch self {
        case .contest: return .orderBook
        }
    }
}
