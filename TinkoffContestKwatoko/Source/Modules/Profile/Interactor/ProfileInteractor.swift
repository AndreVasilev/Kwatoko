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

    let database: IDatabaseService

    var sdk: TinkoffInvestSDK?

    init(database: IDatabaseService) {
        self.database = database
    }
}

extension ProfileInteractor: IProfileInteractor {

    var profile: ProfileEntity? { database.profile }

    func updateProfile(token: String, sandboxToken: String, accountId: String?) {
        database.updateProfile(token: token, sandboxToken: sandboxToken, accountId: accountId)
    }

    func prepareSdk(token: String, sandboxToken: String) {
        let tokenProvider = DefaultTokenProvider(token: token)
        let sandboxTokenProvider = DefaultTokenProvider(token: sandboxToken)
        sdk = TinkoffInvestSDK(appName: Core.appName, tokenProvider: tokenProvider, sandbox: sandboxTokenProvider)
    }

    func getAccounts() -> AnyPublisher<GetAccountsResponse, RPCError> {
        return sdk!.userService.getAccounts()
    }

    func getSandboxAccounts() -> AnyPublisher<GetAccountsResponse, RPCError> {
        return sdk!.sandboxService.getAccounts()

    }
}
