//
//  HistoryPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class HistoryPresenter: BasePresenter {

    enum Section {
        case robots

        var title: String? {
            switch self {
            case .robots: return nil
            }
        }
    }

    let sections: [Section] = [.robots]
    var robots = [Robot]()

    let interactor: IHistoryInteractor
    let router: IHistoryRouter
    weak var viewController: IHistoryView?

    init(interactor: IHistoryInteractor, router: IHistoryRouter) {
        self.interactor = interactor
        self.router = router
        super.init(router: router)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear() {
        super.viewWillAppear()
        reloadRobots()
    }
}

private extension HistoryPresenter {

    func reloadRobots() {
        robots = interactor.fetchRobots()
        viewController?.reloadData()
    }

    func showRobotHistory(at index: Int) {
        let robot = robots[index]
        router.showHistory(robot: robot)
    }
}

extension HistoryPresenter: IHistoryPresenter {

    var robotsCount: Int { robots.count }

    func robotModel(at indexPath: IndexPath) -> RobotsPresenter.RobotModel {
        let robot = robots[indexPath.row]
        return RobotsPresenter.RobotModel(robot: robot,
                                          isRunning: false)
    }

    func didSelectRow(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .robots:
            showRobotHistory(at: indexPath.row)
        }
    }

    func showRobotConfig(at indexPath: IndexPath) {
        let robot = robots[indexPath.row]
        router.showConfig(robot: robot)
    }
}
