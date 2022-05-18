//
//  RobotsAssembly.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class RobotsAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build() -> ViperModule<RobotsViewController, IRobotsRouter> {
        let router = RobotsRouter(addRobotAssembly: modulesFactory.buildAssembly(),
                                  orderBookAssembly: modulesFactory.buildAssembly())
        let interactor = RobotsInteractor(database: modulesFactory.core.databaseService)
        let presenter = RobotsPresenter(interactor: interactor, router: router)
        let viewController = getViewController(presenter: presenter)

        presenter.viewController = viewController
        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IRobotsPresenter) -> RobotsViewController {
        let viewController: RobotsViewController
        if let controller = UIStoryboard(name: "Robots", bundle: nil).instantiateInitialViewController() as? RobotsViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = RobotsViewController(presenter: presenter)
        }
        return viewController
    }
}
