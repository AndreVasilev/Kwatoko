//
//  IRobotsRouter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IRobotsRouter: IBaseRouter {

    func showAddRobot()
    func showRobot(_ robot: Robot)
}
