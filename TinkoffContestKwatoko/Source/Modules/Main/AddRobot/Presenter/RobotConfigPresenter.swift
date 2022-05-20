//
//  RobotConfigPresenter.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 20.05.2022.
//

import Foundation

final class RobotConfigPresenter: BasePresenter {

    let interactor: IAddRobotInteractor
    let router: IAddRobotRouter
    weak var viewController: IAddRobotView?

    let robot: Robot
    let sections: [AddRobotPresenter.Section] = [.strategy, .instrument, .config]
    let actions: [AddRobotPresenter.Action] = []
    let isEditable = false

    init(interactor: IAddRobotInteractor, router: IAddRobotRouter, robot: Robot) {
        self.interactor = interactor
        self.router = router
        self.robot = robot
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension RobotConfigPresenter: IAddRobotPresenter {

    var strategy: Strategy? { robot.strategy }
    var instrument: IInstrument? { robot.config.instrument }
    var config: IStrategyConfig? { robot.config }
    var configCellModel: ContestStrategyConfigCell.Model? { .init(name: robot.name, config: robot.config) }

    func didSelectRow(at indexPath: IndexPath) {

    }

    func didEditConfig(_ model: ContestStrategyConfigCell.Model?) {

    }
}
