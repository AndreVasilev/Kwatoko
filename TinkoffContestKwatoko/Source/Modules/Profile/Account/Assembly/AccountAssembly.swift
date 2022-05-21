//
//  AccountAssembly.swift
//
//  Created by Andrey Vasilev on 21/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit
import TinkoffInvestSDK

final class AccountAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build(account: Account, isSandbox: Bool) -> ViperModule<AccountViewController, IAccountRouter> {
        let router = AccountRouter()
        let interactor = AccountInteractor(sdk: modulesFactory.core.sdk, database: modulesFactory.core.databaseService)
        let presenter = AccountPresenter(interactor: interactor, router: router, account: account, isSandbox: isSandbox)
        let viewController = getViewController(presenter: presenter)

        presenter.viewController = viewController
        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IAccountPresenter) -> AccountViewController {
        let viewController: AccountViewController
        if let controller = UIStoryboard(name: "Account", bundle: nil).instantiateInitialViewController() as? AccountViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = AccountViewController(presenter: presenter)
        }
        return viewController
    }
}
