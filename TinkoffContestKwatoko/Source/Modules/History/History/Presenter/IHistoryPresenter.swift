//
//  IHistoryPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IHistoryPresenter: ILifeCycleOutput {

    var sections: [HistoryPresenter.Section] { get }

    var robotsCount: Int { get }

    func robotModel(at indexPath: IndexPath) -> RobotsPresenter.RobotModel
    func didSelectRow(at indexPath: IndexPath)
    func showRobotConfig(at indexPath: IndexPath)
}
