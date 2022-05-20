//
//  IRobotHistoryPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IRobotHistoryPresenter: ILifeCycleOutput {

    var sections: [RobotHistoryPresenter.Section] { get }
    var deals: [Deal] { get }
    var info: RobotHistoryInfoCell.Model { get }

    func didSelectRow(at indexPath: IndexPath)
    func showRobotConfig()
}
