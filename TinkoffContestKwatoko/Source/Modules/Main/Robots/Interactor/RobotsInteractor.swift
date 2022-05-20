//
//  RobotsInteractor.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class RobotsInteractor {

    let database: IDatabaseService

    init(database: IDatabaseService) {
        self.database = database
    }
}

extension RobotsInteractor: IRobotsInteractor {

    func fetchRobots() -> [Robot] {
        return database.fetchRobots() ?? []
    }

    func deleteRobot(_ robot: Robot) {
        database.deleteRobot(id: robot.id)
    }

    var runningRobotsCount: Int { 0 }

    func isRobotRunning(_ robot: Robot) -> Bool {
        return false
    }

    func stopRobot(_ robot: Robot) {
        
    }
}
