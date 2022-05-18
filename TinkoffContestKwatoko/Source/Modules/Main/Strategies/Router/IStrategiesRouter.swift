//
//  IStrategiesRouter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IStrategiesRouter: IBaseRouter {

    func firstShowInfo(strategy: Strategy)
    func presentInfo(strategy: Strategy)
}
