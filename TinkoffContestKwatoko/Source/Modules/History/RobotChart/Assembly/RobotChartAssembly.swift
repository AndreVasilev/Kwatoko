//
//  RobotChartAssembly.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class RobotChartAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build() -> ViperModule<RobotChartViewController, IRobotChartRouter> {
        let router = RobotChartRouter()
        let interactor = RobotChartInteractor()
        let presenter = RobotChartPresenter(interactor: interactor, router: router)
        let viewController = getViewController(presenter: presenter)

        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IRobotChartPresenter) -> RobotChartViewController {
        let viewController: RobotChartViewController
        if let controller = UIStoryboard(name: "RobotChart", bundle: nil).instantiateInitialViewController() as? RobotChartViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = RobotChartViewController(presenter: presenter)
        }
        return viewController
    }
}
