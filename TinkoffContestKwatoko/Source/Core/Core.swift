//
//  Core.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation
import TinkoffInvestSDK

class Core {

    static let appName = "AndreVasilev.TinkoffInvestSwiftSDK"

    private let fullAccessTokenProvider = DefaultTokenProvider(token: "")
    private let readOnlyTokenProvider = DefaultTokenProvider(token: "")
    private let sandboxTokenProvider = DefaultTokenProvider(token: "")

    private(set) lazy var sdk = TinkoffInvestSDK(appName: Self.appName,
                                                 tokenProvider: readOnlyTokenProvider,
                                                 sandbox: sandboxTokenProvider)

}

extension Core: ICore {

    var networkService: INetworkService {
        return NetworkService()
    }

    var databaseService: IDatabaseService {
        return DatabaseService()
    }
}
