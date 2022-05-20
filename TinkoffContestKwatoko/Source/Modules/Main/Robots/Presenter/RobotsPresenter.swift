//
//  RobotsPresenter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import UIKit

final class RobotsPresenter: BasePresenter {

    enum Section {
        case info, actions, robots

        var title: String? {
            switch self {
            case .info: return "Информация"
            case .actions: return nil
            case .robots: return "Роботы"
            }
        }
    }

    enum Action: IRowAction {
        case runAll, add

        var title: String {
            switch self {
            case .runAll: return "Запустить все"
            case .add: return "Добавить"
            }
        }

        var color: UIColor {
            switch self {
            case .runAll: return .systemGreen
            case .add: return .systemBlue
            }
        }
    }

    struct RobotModel {
        let robot: Robot
        let isRunning: Bool
    }

    struct Info {
        let robotsCount: Int
        let runningCount: Int
    }

    let interactor: IRobotsInteractor
    let router: IRobotsRouter
    weak var viewController: IRobotsView?

    let sections = [Section.info, .actions, .robots]
    var robots = [Robot]()
    let robotsLimit = 10

    init(interactor: IRobotsInteractor, router: IRobotsRouter) {
        self.interactor = interactor
        self.router = router
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        reloadRobots()
    }
}

private extension RobotsPresenter {

    func reloadRobots() {
        robots = interactor.fetchRobots()
        viewController?.reloadData()
    }

    func runAllRobots() {

    }

    func addRobot() {
        router.showAddRobot()
    }

    func showRobot(at index: Int) {
        let robot = robots[index]
        router.showRobot(robot)
    }
}

extension RobotsPresenter: IRobotsPresenter {

    var actions: [Action] {
        var actions = [Action]()
//        if robots.count > 0 {
//            actions.append(.runAll)
//        }
        if robots.count <= robotsLimit {
            actions.append(.add)
        }
        return actions
    }

    var info: Info {
        Info(robotsCount: robots.count,
             runningCount: interactor.runningRobotsCount)
    }

    var robotsCount: Int { robots.count }

    func robotModel(at indexPath: IndexPath) -> RobotsPresenter.RobotModel {
        let robot = robots[indexPath.row]
        return RobotModel(robot: robot,
                          isRunning: interactor.isRobotRunning(robot))
    }

    func didSelectRow(at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .info: break
        case .actions:
            let actions = actions[indexPath.row]
            switch actions {
            case .runAll: runAllRobots()
            case .add: addRobot()
            }
        case .robots:
            showRobot(at: indexPath.row)
        }
    }

    func setRobotState(running: Bool, at indexPath: IndexPath) {
        
    }

    func deleteRobot(at index: Int) {
        let controller = UIAlertController(confirm: "Вы уверены, что хотите удалить робота?", action: "Удалить") { [weak self] in
            guard let robot = self?.robots.remove(at: index) else { return }
            self?.interactor.stopRobot(robot)
            self?.interactor.deleteRobot(robot)
            self?.viewController?.reloadData()
        }
        router.present(controller, animated: true)
    }
}
