//
//  RobotsRouter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class RobotsRouter: BaseRouter {

    let addRobotAssembly: AddRobotAssembly
    let orderBookAssembly: OrderBookAssembly

    init(addRobotAssembly: AddRobotAssembly,
         orderBookAssembly: OrderBookAssembly) {
        self.addRobotAssembly = addRobotAssembly
        self.orderBookAssembly = orderBookAssembly
    }
}

extension RobotsRouter: IRobotsRouter {

    func showAddRobot() {
        let controller = addRobotAssembly.build().viewController
        viewController?.show(controller, sender: nil)
    }

    func showRobot(_ robot: Robot) {
        let controller: UIViewController
        switch robot.strategy {
        case .contest:
            controller = orderBookAssembly.build(robot: robot).viewController
        case .demoContest:
            controller = orderBookAssembly.buildDemo(robot: robot).viewController
        }

        viewController?.show(controller, sender: nil)
    }

    func showConfig(robot: Robot) {
        let controller = addRobotAssembly.build(robot: robot).viewController
        viewController?.show(controller, sender: nil)
    }
}
