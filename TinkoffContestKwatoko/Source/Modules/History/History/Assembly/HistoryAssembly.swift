//
//  HistoryAssembly.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class HistoryAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build() -> ViperModule<HistoryViewController, IHistoryRouter> {
        let router = HistoryRouter(robotHistoryAssembly: modulesFactory.buildAssembly())
        let interactor = HistoryInteractor(database: modulesFactory.core.databaseService)
        let presenter = HistoryPresenter(interactor: interactor, router: router)
        let viewController = getViewController(presenter: presenter)

        presenter.viewController = viewController
        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IHistoryPresenter) -> HistoryViewController {
        let viewController: HistoryViewController
        if let controller = UIStoryboard(name: "History", bundle: nil).instantiateInitialViewController() as? HistoryViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = HistoryViewController(presenter: presenter)
        }
        return viewController
    }
}
