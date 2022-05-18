//
//  IRobotsInteractor.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IRobotsInteractor {

    func fetchRobots() -> [Robot]
    func deleteRobot(_ robot: Robot)

    var runningRobotsCount: Int { get }
    func isRobotRunning(_ robot: Robot) -> Bool
    func stopRobot(_ robot: Robot)
}
