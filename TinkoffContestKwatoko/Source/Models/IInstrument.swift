//
//  InstrumentModel.swift
//  TinkoffContestKwatoko
//
//  Created by Andrey Vasilev on 18.05.2022.
//

import Foundation
import TinkoffInvestSDK

protocol IInstrument {

    var figi: String { get }
    var name: String { get }
    var ticker: String { get }
    var currency: String { get }
}

extension Share: IInstrument {

}
