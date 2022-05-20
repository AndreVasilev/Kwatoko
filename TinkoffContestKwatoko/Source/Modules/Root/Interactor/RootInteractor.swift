//
//  RootInteractor.swift
//
//  Created by Andrey Vasilev on 07/12/2020.
//  Copyright © 2020 Andrey Vasilev. All rights reserved.
//

import Foundation

final class RootInteractor {

    let database: IDatabaseService

    init(database: IDatabaseService) {
        self.database = database
    }
}

extension RootInteractor: IRootInteractor {

    var isAuthorized: Bool { database.profile != nil }
}
