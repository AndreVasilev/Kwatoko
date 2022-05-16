//
//  ProfileAssembly.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class ProfileAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build() -> ViperModule<ProfileViewController, IProfileRouter> {
        let router = ProfileRouter()
        let interactor = ProfileInteractor(database: modulesFactory.core.databaseService)
        let presenter = ProfilePresenter(interactor: interactor, router: router)
        let viewController = getViewController(presenter: presenter)

        presenter.viewController = viewController
        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IProfilePresenter) -> ProfileViewController {
        let viewController: ProfileViewController
        if let controller = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as? ProfileViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = ProfileViewController(presenter: presenter)
        }
        return viewController
    }
}
