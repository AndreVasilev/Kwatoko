//
//  StrategiesRouter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import UIKit

final class StrategiesRouter: BaseRouter {

}

extension StrategiesRouter: IStrategiesRouter {

    func firstShowInfo(strategy: Strategy) {
        let infoController = UIViewController()

        if var controllers = viewController?.navigationController?.viewControllers {
            controllers.removeLast()
            controllers.append(infoController)
            viewController?.navigationController?.setViewControllers(controllers, animated: true)
        } else {
            viewController?.show(infoController, sender: nil)
        }
    }

    func presentInfo(strategy: Strategy) {
        
    }
}
