//
//  HistoryRouter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class HistoryRouter: BaseRouter {

    let robotHistoryAssembly: RobotHistoryAssembly

    init(robotHistoryAssembly: RobotHistoryAssembly) {
        self.robotHistoryAssembly = robotHistoryAssembly
    }
}

extension HistoryRouter: IHistoryRouter {

    func showRobotHistory(_ robot: Robot) {
        let controller = robotHistoryAssembly.build(robot).viewController
        viewController?.show(controller, sender: nil)
    }
}
