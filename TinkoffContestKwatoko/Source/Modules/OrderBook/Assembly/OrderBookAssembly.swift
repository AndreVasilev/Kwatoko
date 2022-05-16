//
//  OrderBookAssembly.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

final class OrderBookAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build(model: OrderBookPresenter.Model) -> ViperModule<OrderBookViewController, IOrderBookRouter> {
        let router = OrderBookRouter()
        let interactor = OrderBookInteractor(sdk: modulesFactory.core.sdk)
        let presenter = OrderBookPresenter(interactor: interactor, router: router, model: model)
        let viewController = getViewController(presenter: presenter)

        presenter.viewController = viewController
        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IOrderBookPresenter) -> OrderBookViewController {
        let viewController: OrderBookViewController
        if let controller = UIStoryboard(name: "OrderBook", bundle: nil).instantiateInitialViewController() as? OrderBookViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = OrderBookViewController(presenter: presenter)
        }
        return viewController
    }
}
