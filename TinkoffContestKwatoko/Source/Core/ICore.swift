//
//  ICore.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation
import TinkoffInvestSDK

protocol ICore {

    var sdk: TinkoffInvestSDK { get }

    var networkService: INetworkService { get }
    var databaseService: IDatabaseService { get }
}
