//
//  Strategy.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import Foundation

enum Strategy: String, CaseIterable {

    case demoContest, contest
}

extension Strategy {

    enum Kind {
        case orderBook
    }

    var name: String {
        switch self {
        case .demoContest: return "Демо: торговля по стакану"
        case .contest: return "Торговля по стакану"
        }
    }

    var kind: Kind {
        switch self {
        case .demoContest, .contest: return .orderBook
        }
    }
}
