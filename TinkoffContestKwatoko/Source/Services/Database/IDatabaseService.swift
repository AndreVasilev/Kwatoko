//
//  IDatabaseService.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

protocol IDatabaseService {

    var profile: ProfileEntity? { get }

    func updateProfile(token: String, sandboxToken: String, accountId: String?)

    // MARK: Robots
    func fetchRobots() -> [Robot]?
    func addRobot(name: String, strategy: Strategy, config: IStrategyConfig) -> Robot?
    func deleteRobot(id: String, configId: String)

    // MARK: Deals
    func fetchDeals(robotId: String) -> [Deal]
}
