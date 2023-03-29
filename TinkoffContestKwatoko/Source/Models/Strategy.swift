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
        case .demoContest: return L10n.Localization.strategyTitleContestDemo
        case .contest: return L10n.Localization.strategyTitleContest
        }
    }

    var kind: Kind {
        switch self {
        case .demoContest, .contest: return .orderBook
        }
    }
    
    var tutorial: Tutorial {
        switch self {
        case .demoContest, .contest: return ContestStrategy.tutorial
        }
    }
}
