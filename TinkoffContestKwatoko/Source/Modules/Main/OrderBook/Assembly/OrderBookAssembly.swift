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

    func build(robot: Robot) -> ViperModule<OrderBookViewController, IOrderBookRouter> {
        let interactor = OrderBookInteractor(sdk: modulesFactory.core.sdk)
        return build(robot: robot, interactor: interactor)
    }
    
    func buildDemo(robot: Robot) -> ViperModule<OrderBookViewController, IOrderBookRouter> {
        var data: Data?
        if let url = Bundle.main.url(forResource: "DemoData", withExtension: "json") {
            do {
                data = try Data(contentsOf: url)
            } catch {
                print(error)
            }
        }
        let interactor = DemoOrderBookInteractor(data: data)
        return build(robot: robot, interactor: interactor)
    }
    
    private func build(robot: Robot, interactor: IOrderBookInteractor) -> ViperModule<OrderBookViewController, IOrderBookRouter> {
        let router = OrderBookRouter()
        let strategy: IOrderBookStrategy
        switch robot.strategy {
        case .contest:
            #warning("todo")
            strategy = ContestStrategy(ordersService: modulesFactory.core.sdk.sandboxService as! DemoOrdersService,
                                       database: modulesFactory.core.databaseService,
                                       robot: robot)
        case .demoContest:
            strategy = ContestStrategy(ordersService: DemoOrdersService(),
                                       database: modulesFactory.core.databaseService,
                                       robot: robot)
            
        }
        let presenter = OrderBookPresenter(interactor: interactor, router: router, strategy: strategy)
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
