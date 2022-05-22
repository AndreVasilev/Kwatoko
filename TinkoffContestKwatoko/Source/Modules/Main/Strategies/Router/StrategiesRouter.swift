//
//  StrategiesRouter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import UIKit

final class StrategiesRouter: BaseRouter {

    let tutorialAssembly: TutorialAssembly
    
    init(tutorialAssembly: TutorialAssembly) {
        self.tutorialAssembly = tutorialAssembly
    }
}

extension StrategiesRouter: IStrategiesRouter {

    func firstShowInfo(strategy: Strategy) {
        let infoController = infoController(strategy: strategy)

        if var controllers = viewController?.navigationController?.viewControllers {
            controllers.removeLast()
            controllers.append(infoController)
            viewController?.navigationController?.setViewControllers(controllers, animated: true)
        } else {
            viewController?.show(infoController, sender: nil)
        }
    }

    func showInfo(strategy: Strategy) {
        let controller = infoController(strategy: strategy)
        viewController?.show(controller, sender: nil)
    }
}

private extension StrategiesRouter {
    
    func infoController(strategy: Strategy) -> UIViewController {
        return tutorialAssembly.build(tutorial: strategy.tutorial).viewController
    }
}
