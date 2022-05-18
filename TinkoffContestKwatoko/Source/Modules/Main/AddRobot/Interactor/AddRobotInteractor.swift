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

    var accountId: String? { database.profile?.selectedAccountId }

    func didOpenInfo(strategy: Strategy) -> Bool {
        return true
    }

    func addRobot(name: String, strategy: Strategy, config: IStrategyConfig) -> Robot? {
        return database.addRobot(name: name, strategy: strategy, config: config)
    }
}
