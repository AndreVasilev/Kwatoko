//
//  AddRobotAssembly.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class AddRobotAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build() -> ViperModule<AddRobotViewController, IAddRobotRouter> {
        let router = AddRobotRouter(strategiesAssembly: modulesFactory.buildAssembly(),
                                    instrumentsAssembly: modulesFactory.buildAssembly(),
                                    orderBookAssembly: modulesFactory.buildAssembly())
        let interactor = AddRobotInteractor(database: modulesFactory.core.databaseService)
        let presenter = AddRobotPresenter(interactor: interactor, router: router)
        let viewController = getViewController(presenter: presenter)

        presenter.viewController = viewController
        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IAddRobotPresenter) -> AddRobotViewController {
        let viewController: AddRobotViewController
        if let controller = UIStoryboard(name: "AddRobot", bundle: nil).instantiateInitialViewController() as? AddRobotViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = AddRobotViewController(presenter: presenter)
        }
        return viewController
    }
}
