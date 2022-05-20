//
//  RobotModel.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import Foundation

struct Robot {
    let id: String
    let name: String
    let strategy: Strategy
    let config: IStrategyConfig
    let created: Date
}

extension Robot {

    init?(_ entity: RobotEntity) {
        guard let id = entity.id,
              let name = entity.name,
              let created = entity.created,
              let strategyValue = entity.strategy,
              let strategy = Strategy(rawValue: strategyValue),
              let configEntity = entity.config,
              let config = ContestStrategy.Config(configEntity)
        else { return nil }

        self.init(id: id, name: name, strategy: strategy, config: config, created: created)
    }

    var description: String {
        return "\(strategy.name) :: \(config.instrument.ticker)"
    }
}

