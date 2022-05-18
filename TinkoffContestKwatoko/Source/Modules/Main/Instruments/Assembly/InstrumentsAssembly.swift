//
//  InstrumentsAssembly.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class InstrumentsAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build(callback: InstrumentsPresenter.Callback?) -> ViperModule<InstrumentsViewController, IInstrumentsRouter> {
        let router = InstrumentsRouter()
        let interactor = InstrumentsInteractor(sdk: modulesFactory.core.sdk)
        let presenter = InstrumentsPresenter(interactor: interactor, router: router, callback: callback)
        let viewController = getViewController(presenter: presenter)

        presenter.viewController = viewController
        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IInstrumentsPresenter) -> InstrumentsViewController {
        let viewController: InstrumentsViewController
        if let controller = UIStoryboard(name: "Instruments", bundle: nil).instantiateInitialViewController() as? InstrumentsViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = InstrumentsViewController(presenter: presenter)
        }
        return viewController
    }
}
