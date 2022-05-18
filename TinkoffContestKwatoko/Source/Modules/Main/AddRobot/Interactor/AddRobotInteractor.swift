//
//  AddRobotInteractor.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class AddRobotInteractor {

    let database: IDatabaseService

    init(database: IDatabaseService) {
        self.database = database
    }
}

extension AddRobotInteractor: IAddRobotInteractor {

    var accountId: String? { "103e792d-a4d1-4451-878a-7e7fc63249b7" }

    func didOpenInfo(strategy: Strategy) -> Bool {
        return true
    }

    func addRobot(name: String, strategy: Strategy, config: IStrategyConfig) -> Robot? {
        return database.addRobot(name: name, strategy: strategy, config: config)
    }
}
