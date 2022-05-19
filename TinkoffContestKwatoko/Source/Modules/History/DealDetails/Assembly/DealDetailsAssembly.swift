//
//  DealDetailsAssembly.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class DealDetailsAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build(_ deal: Deal) -> ViperModule<DealDetailsViewController, IDealDetailsRouter> {
        let router = DealDetailsRouter()
        let interactor = DealDetailsInteractor()
        let presenter = DealDetailsPresenter(interactor: interactor, router: router, deal: deal)
        let viewController = getViewController(presenter: presenter)

        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IDealDetailsPresenter) -> DealDetailsViewController {
        let viewController: DealDetailsViewController
        if let controller = UIStoryboard(name: "DealDetails", bundle: nil).instantiateInitialViewController() as? DealDetailsViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = DealDetailsViewController(presenter: presenter)
        }
        return viewController
    }
}
