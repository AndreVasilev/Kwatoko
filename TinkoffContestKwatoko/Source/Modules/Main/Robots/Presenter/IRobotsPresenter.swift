//
//  IRobotsPresenter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IRobotsPresenter: ILifeCycleOutput {

    var sections: [RobotsPresenter.Section] { get }
    var actions: [RobotsPresenter.Action] { get }

    var info: RobotsPresenter.Info { get }
    var robotsCount: Int { get }

    func robotModel(at indexPath: IndexPath) -> RobotsPresenter.RobotModel
    func didSelectRow(at indexPath: IndexPath)
    func setRobotState(running: Bool, at indexPath: IndexPath)
    func deleteRobot(at index: Int)
}
