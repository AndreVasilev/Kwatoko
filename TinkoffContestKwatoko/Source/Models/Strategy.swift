//
//  Strategy.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import Foundation

enum Strategy: String, CaseIterable {

    case demoContest, contest
    case demoBuyingAnomaly, buyingAnomaly
}

extension Strategy {

    enum Kind {
        case orderBook
    }

    var name: String {
        switch self {
        case .demoContest: return "Демо: торговля по стакану"
        case .contest: return "Торговля по стакану"
        case .demoBuyingAnomaly: return "Демо: Покупка аномальной заявки"
        case .buyingAnomaly: return "Покупка аномальной заявки"
        }
    }

    var kind: Kind {
        switch self {
        case .demoContest, .contest, .buyingAnomaly, .demoBuyingAnomaly: return .orderBook
        }
    }
    
    var tutorial: Tutorial {
        switch self {
        case .demoContest, .contest: return ContestStrategy.tutorial
        case .demoBuyingAnomaly, .buyingAnomaly: return LionStrategy.tutorial
        }
    }
}
