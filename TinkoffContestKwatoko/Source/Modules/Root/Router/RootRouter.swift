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

    func presentLogin(delegate: UITabBarControllerDelegate?) {
        let controllers = [profileController]
        presentMainTabBarController(children: controllers, delegate: delegate)
    }

    func presentMain(delegate: UITabBarControllerDelegate?) {
        let controllers = [robotsController, historyController, profileController]
        var index: Int = 0
        if let tabBarController = viewController?.children.first as? UITabBarController,
           let selectedController = (tabBarController.selectedViewController as? UINavigationController)?.viewControllers.last,
           selectedController is ProfileViewController,
           let profileIndex = controllers.firstIndex(where: { $0 is ProfileViewController }) {
            index = profileIndex
        }
        presentMainTabBarController(children: controllers, selectedAt: index, delegate: delegate)
    }
}

private extension RootRouter {

    func embed(child controller: UIViewController, animated: Bool = true, _ completion: (() -> Void)? = nil) {
        controller.view.frame = viewController?.view.bounds ?? .zero

        if animated,
           let child = viewController?.children.first {
            child.willMove(toParent: nil)
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

    func presentMainTabBarController(children: [UIViewController], selectedAt index: Int = 0, delegate: UITabBarControllerDelegate?) {
        let mainController = mainTabBarController(controllers: children, delegate: delegate)
        mainController.selectedIndex = index
        embed(child: mainController)
    }

    func mainTabBarController(controllers: [UIViewController], delegate: UITabBarControllerDelegate?) -> UITabBarController {
        let navigationControllers: [UINavigationController] = controllers.map {
            let nc = UINavigationController(rootViewController: $0)
            nc.navigationBar.prefersLargeTitles = true
            return nc
        }
        
        let tabBarControler = UITabBarController()
        tabBarControler.setViewControllers(navigationControllers, animated: false)
        tabBarControler.delegate = delegate
        return tabBarControler
    }

    var robotsController: UIViewController {
        let assembly: RobotsAssembly = modulesFactory.buildAssembly()
        let viewController = assembly.build().viewController
        viewController.title = L10n.Localization.robots
        viewController.tabBarItem = UITabBarItem(title: L10n.Localization.robots,
                                                 image: Asset.robots.image,
                                                 tag: 2)
        return viewController
    }

    var historyController: UIViewController {
        let assembly: HistoryAssembly = modulesFactory.buildAssembly()
        let viewController = assembly.build().viewController
        viewController.title = L10n.Localization.history
        viewController.tabBarItem = UITabBarItem(title: L10n.Localization.history,
                                                 image: Asset.history.image,
                                                 tag: 2)
        return viewController
    }

    var profileController: UIViewController {
        let assembly: ProfileAssembly = modulesFactory.buildAssembly()
        let viewController = assembly.build().viewController
        viewController.title = L10n.Localization.profile
        viewController.tabBarItem = UITabBarItem(title: L10n.Localization.profile,
                                                 image: Asset.profile.image,
                                                 tag: 2)
        return viewController
    }
}
