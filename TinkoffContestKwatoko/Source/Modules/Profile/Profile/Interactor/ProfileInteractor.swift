//
//  ProfileInteractor.swift
//
//  Created by Andrey Vasilev on 16/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation
import TinkoffInvestSDK
import CombineGRPC
import Combine

final class ProfileInteractor {

    let core: ICore
    lazy var database: IDatabaseService = core.databaseService
    var sdk: TinkoffInvestSDK?

    init(core: ICore) {
        self.core = core
    }
}

extension ProfileInteractor: IProfileInteractor {

    func fetchProfile() -> Profile? {
        return database.profile
    }

    func updateProfile(token: String, sandboxToken: String, accountId: String?) {
        database.updateProfile(token: token, sandboxToken: sandboxToken, accountId: accountId)
    }

    func prepareSdk(token: String, sandboxToken: String) {
        sdk = core.buildSdk(token: token, sandboxToken: sandboxToken)
    }

    func getAccounts() -> AnyPublisher<GetAccountsResponse, RPCError> {
        return sdk!.userService.getAccounts()
    }

    func getSandboxAccounts() -> AnyPublisher<GetAccountsResponse, RPCError> {
        return sdk!.sandboxService.getAccounts()
    }

    func clearDatabase() {
        database.clear()
    }

    func openSandboxAccount() -> AnyPublisher<OpenSandboxAccountResponse, RPCError> {
        return sdk!.sandboxService.openAccount()
    }
    
    func fetchAccounts() -> [AccountModel] {
        return database.fetchAccounts()
    }
}
