//
//  RobotChartAssembly.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import UIKit

protocol IRobotChartCellAssembly {

    func build(deals: [Deal], tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}

final class RobotChartAssembly: IAssembly {

    private let modulesFactory: IModulesFactory

    init(modulesFactory: IModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    func build(deals: [Deal]) -> ViperModule<RobotChartViewController, IRobotChartRouter> {
        let router = RobotChartRouter()
        let interactor = RobotChartInteractor()
        let presenter = RobotChartPresenter(interactor: interactor, router: router, deals: deals)
        let viewController = getViewController(presenter: presenter)

        presenter.view = viewController
        router.viewController = viewController

        return ViperModule(viewController: viewController, router: router)
    }

    func getViewController(presenter: IRobotChartPresenter) -> RobotChartViewController {
        let viewController: RobotChartViewController
        if let controller = UIStoryboard(name: "RobotChart", bundle: nil).instantiateInitialViewController() as? RobotChartViewController {
            viewController = controller
            viewController.output = presenter
            viewController.presenter = presenter
        } else {
            viewController = RobotChartViewController(presenter: presenter)
        }
        return viewController
    }
}

extension RobotChartAssembly: IRobotChartCellAssembly {

    func build(deals: [Deal], tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RobotChartCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? RobotChartCell {
            let router = RobotChartRouter()
            let interactor = RobotChartInteractor()
            let presenter = RobotChartPresenter(interactor: interactor, router: router, deals: deals)
            presenter.drawValuesEnabled = false
            presenter.drawCircles = false
            presenter.view = cell
            cell.presenter = presenter
        }
        return cell
    }
}
