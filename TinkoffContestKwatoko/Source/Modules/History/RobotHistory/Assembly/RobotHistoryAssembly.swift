//
//  RobotHistoryAssembly.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class RobotHistoryAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build(_ robot: Robot) -> ViperModule<RobotHistoryViewController, IRobotHistoryRouter> {
        let router = RobotHistoryRouter(dealDetailsAssembly: modulesFactory.buildAssembly(),
                                        robotChartAssembly: modulesFactory.buildAssembly(),
                                        addRobotAssembly: modulesFactory.buildAssembly())
        let interactor = RobotHistoryInteractor(database: modulesFactory.core.databaseService)
        let presenter = RobotHistoryPresenter(interactor: interactor, router: router, robot: robot)
        let viewController = getViewController(presenter: presenter)

        viewController.chartCellAssembly = modulesFactory.buildAssembly() as RobotChartAssembly
        presenter.viewController = viewController
        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IRobotHistoryPresenter) -> RobotHistoryViewController {
        let viewController: RobotHistoryViewController
        if let controller = UIStoryboard(name: "RobotHistory", bundle: nil).instantiateInitialViewController() as? RobotHistoryViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = RobotHistoryViewController(presenter: presenter)
        }
        return viewController
    }
}
