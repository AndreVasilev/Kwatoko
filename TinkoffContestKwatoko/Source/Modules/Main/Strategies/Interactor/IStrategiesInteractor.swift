//
//  IStrategiesInteractor.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IStrategiesInteractor {

    func setDidOpenInfo(strategy: Strategy)
    func didOpenInfo(strategy: Strategy) -> Bool
}
