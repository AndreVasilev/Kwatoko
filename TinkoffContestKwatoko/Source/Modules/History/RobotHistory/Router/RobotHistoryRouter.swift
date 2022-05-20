//
//  RobotHistoryRouter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class RobotHistoryRouter: BaseRouter {

    let dealDetailsAssembly: DealDetailsAssembly
    let robotChartAssembly: RobotChartAssembly
    let addRobotAssembly: AddRobotAssembly

    init(dealDetailsAssembly: DealDetailsAssembly,
         robotChartAssembly: RobotChartAssembly,
         addRobotAssembly: AddRobotAssembly) {
        self.dealDetailsAssembly = dealDetailsAssembly
        self.robotChartAssembly = robotChartAssembly
        self.addRobotAssembly = addRobotAssembly
    }
}

extension RobotHistoryRouter: IRobotHistoryRouter {

    func showDetails(deal: Deal) {
        let controller = dealDetailsAssembly.build(deal).viewController
        viewController?.show(controller, sender: nil)
    }

    func showChart(deals: [Deal]) {
        let controller = robotChartAssembly.build(deals: deals).viewController
        viewController?.show(controller, sender: nil)
    }

    func showConfig(robot: Robot) {
        let controller = addRobotAssembly.build(robot: robot).viewController
        viewController?.show(controller, sender: nil)
    }
}
