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

    init(dealDetailsAssembly: DealDetailsAssembly,
         robotChartAssembly: RobotChartAssembly) {
        self.dealDetailsAssembly = dealDetailsAssembly
        self.robotChartAssembly = robotChartAssembly
    }
}

extension RobotHistoryRouter: IRobotHistoryRouter {

    func showDealDetails(deal: Deal) {
        let controller = dealDetailsAssembly.build(deal).viewController
        viewController?.show(controller, sender: nil)
    }

    func showChart(deals: [Deal]) {
        let controller = robotChartAssembly.build(deals: deals).viewController
        viewController?.show(controller, sender: nil)
    }
}
