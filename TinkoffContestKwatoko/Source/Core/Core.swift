//
//  Core.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation
import TinkoffInvestSDK

class Core {

    private let appName = "AndreVasilev.Kwatoko"

    private(set) lazy var sdk: TinkoffInvestSDK = {
        let profile = databaseService.profile
        let token = profile?.token ?? ""
        let sandboxToken = profile?.token ?? ""
        return buildSdk(token: token, sandboxToken: sandboxToken)
    }()

    private(set) lazy var databaseService: IDatabaseService = DatabaseService()
}

extension Core: ICore {

    func buildSdk(token: String, sandboxToken: String) -> TinkoffInvestSDK {
        let tokenProvider = DefaultTokenProvider(token: token)
        let sandboxTokenProvider = DefaultTokenProvider(token: sandboxToken)
        return TinkoffInvestSDK(appName: appName, tokenProvider: tokenProvider, sandbox: sandboxTokenProvider)
    }

    var networkService: INetworkService {
        return NetworkService()
    }
}
