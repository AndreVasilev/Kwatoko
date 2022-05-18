//
//  IAddRobotInteractor.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IAddRobotInteractor {

    var accountId: String? { get }

    func didOpenInfo(strategy: Strategy) -> Bool
    func addRobot(name: String, strategy: Strategy, config: IStrategyConfig) -> Robot?
}
