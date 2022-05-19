//
//  RobotHistoryInteractor.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class RobotHistoryInteractor {

    let database: IDatabaseService

    init(database: IDatabaseService) {
        self.database = database
    }
}

extension RobotHistoryInteractor: IRobotHistoryInteractor {

    func fetchDeals(robotId: String) -> [Deal] {
        return database.fetchDeals(robotId: robotId)
    }
}
