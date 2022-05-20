//
//  HistoryRouter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class HistoryRouter: BaseRouter {

    let robotHistoryAssembly: RobotHistoryAssembly
    let addRobotAssembly: AddRobotAssembly

    init(robotHistoryAssembly: RobotHistoryAssembly,
         addRobotAssembly: AddRobotAssembly) {
        self.robotHistoryAssembly = robotHistoryAssembly
        self.addRobotAssembly = addRobotAssembly
    }
}

extension HistoryRouter: IHistoryRouter {

    func showHistory(robot: Robot) {
        let controller = robotHistoryAssembly.build(robot).viewController
        viewController?.show(controller, sender: nil)
    }

    func showConfig(robot: Robot) {
        let controller = addRobotAssembly.build(robot: robot).viewController
        viewController?.show(controller, sender: nil)
    }
}
