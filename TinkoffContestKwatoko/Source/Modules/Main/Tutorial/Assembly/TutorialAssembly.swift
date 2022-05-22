//
//  TutorialAssembly.swift
//
//  Created by Andrey Vasilev on 22/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class TutorialAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build(tutorial: Tutorial) -> ViperModule<TutorialViewController, ITutorialRouter> {
        let router = TutorialRouter()
        let interactor = TutorialInteractor()
        let presenter = TutorialPresenter(interactor: interactor, router: router, tutorial: tutorial)
        let viewController = getViewController(presenter: presenter)

        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: ITutorialPresenter) -> TutorialViewController {
        let viewController: TutorialViewController
        if let controller = UIStoryboard(name: "Tutorial", bundle: nil).instantiateInitialViewController() as? TutorialViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = TutorialViewController(presenter: presenter)
        }
        return viewController
    }
}
