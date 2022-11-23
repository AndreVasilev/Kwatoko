//
//  AddRobotRouter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import UIKit

final class AddRobotRouter: BaseRouter {

    let strategiesAssembly: StrategiesAssembly
    let instrumentsAssembly: InstrumentsAssembly
    let orderBookAssembly: OrderBookAssembly

    init(strategiesAssembly: StrategiesAssembly,
         instrumentsAssembly: InstrumentsAssembly,
         orderBookAssembly: OrderBookAssembly) {
        self.strategiesAssembly = strategiesAssembly
        self.instrumentsAssembly = instrumentsAssembly
        self.orderBookAssembly = orderBookAssembly
    }
}

extension AddRobotRouter: IAddRobotRouter {

    func showInstruments(callback: @escaping InstrumentsPresenter.Callback) {
        let controller = instrumentsAssembly.build(callback: callback).viewController
        viewController?.show(controller, sender: nil)
    }

    func showStrategies(callback: @escaping StrategiesPresenter.Callback) {
        let controller = strategiesAssembly.build(callback: callback).viewController
        viewController?.show(controller, sender: nil)
    }

    func showRobot(_ robot: Robot) {
        let controller: UIViewController
        switch robot.strategy {
        case .contest:
            controller = orderBookAssembly.build(robot: robot).viewController
        case .demoContest:
            controller = orderBookAssembly.buildDemo(robot: robot).viewController
        case .buyingAnomaly:
            controller = orderBookAssembly.build(robot: robot).viewController
        case .demoBuyingAnomaly:
            controller = orderBookAssembly.buildDemo(robot: robot).viewController
        }

        if var controllers = viewController?.navigationController?.viewControllers {
            controllers.removeLast()
            controllers.append(controller)
            viewController?.navigationController?.setViewControllers(controllers, animated: true)
        } else {
            viewController?.show(controller, sender: nil)
        }
    }
}
