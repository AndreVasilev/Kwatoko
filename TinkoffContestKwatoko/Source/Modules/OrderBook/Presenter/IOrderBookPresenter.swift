//
//  IOrderBookPresenter.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IOrderBookPresenter: ILifeCycleOutput {

    var sections: [OrderBookPresenter.Section] { get }
    
    func rows(in section: OrderBookPresenter.Section) -> [OrderBookCell.Model]
    func didSelectRow(at indexPath: IndexPath)
}
