//
//  Core.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

class Core {

}

extension Core: ICore {

    var networkService: INetworkService {
        return NetworkService()
    }

    var databaseService: IDatabaseService {
        return DatabaseService()
    }
}
