//
//  RootRouter.swift
//
//  Created by Andrey Vasilev on 07/12/2020.
//  Copyright © 2020 Andrey Vasilev. All rights reserved.
//

import UIKit

final class RootRouter: BaseRouter {

    let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }
}

extension RootRouter: IRootRouter {

    func presentMain() {
        let controller = mainTabBarController()
        embed(child: controller)
    }
}

private extension RootRouter {

    func embed(child controller: UIViewController, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        controller.view.frame = viewController?.view.bounds ?? .zero

        if animated,
           let child = viewController?.children.first {
            viewController?.children.first?.willMove(toParent: nil)
            viewController?.addChild(controller)

            controller.view.alpha = 0
            viewController?.view.addSubview(controller.view)

            viewController?.transition(from: child, to: controller, duration: 0.25, options: [], animations: {
                controller.view.alpha = 1
            }, completion: { _ in
                child.removeFromParent()
                controller.didMove(toParent: self.viewController)
                completion?()
            })
        } else {
            viewController?.addChild(controller)
            viewController?.view.addSubview(controller.view)
            controller.didMove(toParent: viewController)
            completion?()
        }
    }

    func mainTabBarController() -> UITabBarController {
        let controllers = [robotsController, profileController]
            .map { UINavigationController(rootViewController: $0) }

        let tabBarControler = UITabBarController()
        tabBarControler.setViewControllers(controllers, animated: false)
        return tabBarControler
    }

    var robotsController: UIViewController {
        let assembly: RobotsAssembly = modulesFactory.buildAssembly()
        let viewController = assembly.build().viewController
        viewController.title = "Роботы"
        return viewController
    }

    var profileController: UIViewController {
        let assembly: ProfileAssembly = modulesFactory.buildAssembly()
        let viewController = assembly.build().viewController
        viewController.title = "Профиль"
        return viewController
    }
}
