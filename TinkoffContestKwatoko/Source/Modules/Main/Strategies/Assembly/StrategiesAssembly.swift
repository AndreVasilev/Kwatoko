//
//  StrategiesAssembly.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class StrategiesAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build(callback: StrategiesPresenter.Callback?) -> ViperModule<StrategiesViewController, IStrategiesRouter> {
        let router = StrategiesRouter(tutorialAssembly: modulesFactory.buildAssembly())
        let interactor = StrategiesInteractor()
        let presenter = StrategiesPresenter(interactor: interactor, router: router, callback: callback)
        let viewController = getViewController(presenter: presenter)

        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IStrategiesPresenter) -> StrategiesViewController {
        let viewController: StrategiesViewController
        if let controller = UIStoryboard(name: "Strategies", bundle: nil).instantiateInitialViewController() as? StrategiesViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = StrategiesViewController(presenter: presenter)
        }
        return viewController
    }
}
