//
//  IAddRobotRouter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IAddRobotRouter: IBaseRouter {

    func showInstruments(callback: @escaping InstrumentsPresenter.Callback)
    func showStrategies(callback: @escaping StrategiesPresenter.Callback)
    func showRobot(_ robot: Robot)
}
