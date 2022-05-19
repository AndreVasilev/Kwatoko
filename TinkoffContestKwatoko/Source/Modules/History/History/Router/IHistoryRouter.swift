//
//  IHistoryRouter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IHistoryRouter: IBaseRouter {

    func showRobotHistory(_ robot: Robot)
}
