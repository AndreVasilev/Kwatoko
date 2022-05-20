//
//  RootAssembly.swift
//
//  Created by Andrey Vasilev on 07/12/2020.
//  Copyright © 2020 Andrey Vasilev. All rights reserved.
//

import UIKit

final class RootAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build() -> ViperModule<RootViewController, IRootRouter> {
        let router = RootRouter(modulesFactory: modulesFactory)
        let interactor = RootInteractor(database: modulesFactory.core.databaseService)
        let presenter = RootPresenter(interactor: interactor, router: router)
        let viewController = getViewController(presenter: presenter)

        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IRootPresenter) -> RootViewController {
        let viewController: RootViewController
        if let controller = UIStoryboard(name: "Root", bundle: nil).instantiateInitialViewController() as? RootViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = RootViewController(presenter: presenter)
        }
        return viewController
    }
}
