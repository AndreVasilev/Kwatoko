//
//  HistoryInteractor.swift
//
//  Created by Andrey Vasilev on 18/05/2022.
//  Copyright © 2022 Andrey Vasilev. All rights reserved.
//

import Foundation

final class HistoryInteractor {

    let database: IDatabaseService

    init(database: IDatabaseService) {
        self.database = database
    }
}

extension HistoryInteractor: IHistoryInteractor {

    func fetchRobots() -> [Robot] {
        return database.fetchRobots() ?? []
    }
}
