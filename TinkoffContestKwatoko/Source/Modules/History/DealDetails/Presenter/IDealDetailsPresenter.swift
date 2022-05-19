//
//  IDealDetailsPresenter.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IDealDetailsPresenter: ILifeCycleOutput {

    var sections: [DealDetailsPresenter.Section] { get }
    var deal: Deal { get }

    func numberOfRows(in section: Int) -> Int
    func bookOrderModel(at indexPath: IndexPath) -> DealDetailsBookOrderCell.Model?
    func titleForSection(_ section: Int) -> String?
}
