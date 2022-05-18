//
//  IInstrumentsPresenter.swift
//
//  Created by Andrey Vasilev on 17/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

protocol IInstrumentsPresenter: ILifeCycleOutput {

    var sections: [InstrumentsPresenter.Section] { get }

    func instrumentsCount(in section: Int) -> Int
    func instrument(at indexPath: IndexPath) -> InstrumentListCell.Model?

    func didSelectRow(at indexPath: IndexPath)
    func presentInfo(at indexPath: IndexPath)

    func filterInstruments(query: String?)
}
