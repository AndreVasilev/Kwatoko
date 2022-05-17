//
//  ICore.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation
import TinkoffInvestSDK

protocol ICore {

    var sdk: TinkoffInvestSDK { get }
    func buildSdk(token: String, sandboxToken: String) -> TinkoffInvestSDK

    var networkService: INetworkService { get }
    var databaseService: IDatabaseService { get }

}
