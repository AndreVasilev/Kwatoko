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
        let controllers = [orderBookController]
            .map { UINavigationController(rootViewController: $0) }

        let tabBarControler = UITabBarController()
        tabBarControler.setViewControllers(controllers, animated: false)
        return tabBarControler
    }

    var orderBookController: UIViewController {
        let model = OrderBookPresenter.Model(accountID: "103e792d-a4d1-4451-878a-7e7fc63249b7",
                                             figi: "BBG004730N88",
                                             depth: 20,
                                             currency: .rub,
                                             orderDirection: .unspecified,
                                             edgeQuantity: 5000,
                                             orderQuantity: 1,
                                             orderDelta: 0.1,
                                             stopLossPercent: 0.1,
                                             takeProfitPercent: 0.5)
        let assembly: OrderBookAssembly = modulesFactory.buildAssembly()
        let viewController = assembly.build(model: model).viewController
        viewController.title = "OrderBook"
        return viewController
    }
}
