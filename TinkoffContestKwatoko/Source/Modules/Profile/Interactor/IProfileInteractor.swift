//
//  IProfileInteractor.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import Combine
import TinkoffInvestSDK
import CombineGRPC

protocol IProfileInteractor {

    var profile: Profile? { get }

    func updateProfile(token: String, sandboxToken: String, accountId: String?)

    func prepareSdk(token: String, sandboxToken: String)
    func getAccounts() -> AnyPublisher<GetAccountsResponse, RPCError>
    func getSandboxAccounts() -> AnyPublisher<GetAccountsResponse, RPCError>
}
