//
//  IProfilePresenter.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IProfilePresenter: ILifeCycleOutput {

    var sections: [ProfilePresenter.Section] { get }

    var tokensModel: ProfileTokensCell.Model { get set }

    func numberOfRows(inSection index: Int) -> Int
    func accountModel(at indexPath: IndexPath) -> ProfileAccountCell.Model?
    func action(at indexPath: IndexPath) -> IRowAction?

    func didSelectRow(at indexPath: IndexPath)
}
