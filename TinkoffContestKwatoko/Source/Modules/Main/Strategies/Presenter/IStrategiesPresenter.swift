//
//  IStrategiesPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IStrategiesPresenter: ILifeCycleOutput {

    var strategies: [Strategy] { get }

    func didSelectRow(at indexPath: IndexPath)
    func presentStrategyInfo(at indexPath: IndexPath)
}
