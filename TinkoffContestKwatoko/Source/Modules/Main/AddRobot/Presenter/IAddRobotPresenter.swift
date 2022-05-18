//
//  IAddRobotPresenter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK

protocol IAddRobotPresenter: ILifeCycleOutput {

    var sections: [AddRobotPresenter.Section] { get }
    var actions: [AddRobotPresenter.Action] { get }
    var strategy: Strategy? { get }
    var instrument: IInstrument? { get }
    var configCellModel: ContestStrategyConfigCell.Model? { get }

    func didSelectRow(at indexPath: IndexPath)
    func didEditConfig(_ model: ContestStrategyConfigCell.Model?)
}
