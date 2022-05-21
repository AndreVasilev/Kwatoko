//
//  IAccountPresenter.swift
//
//  Created by Andrey Vasilev on 21/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IAccountPresenter: ILifeCycleOutput {

    var sections: [AccountPresenter.Section] { get }
    var infoRows: [AccountPresenter.InfoRow] { get }
    var info: AccountPresenter.Info { get }
    
    func numberOfRows(inSection index: Int) -> Int
    func position(at indexPath: IndexPath) -> IAccountPosition?
    func action(at indexPath: IndexPath) -> IRowAction?
    func didSelectRow(at indexPath: IndexPath)

    func updateAccount(name: String?)
    func payInCurrency(at indexPath: IndexPath)
}
