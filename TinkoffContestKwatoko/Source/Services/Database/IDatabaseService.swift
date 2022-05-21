//
//  IDatabaseService.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation

protocol IDatabaseService {

    func clear()

    // MARK: Profile

    var profile: Profile? { get }
    func updateProfile(token: String, sandboxToken: String, accountId: String?, isSandbox: Bool)

    // MARK: Robots
    
    func fetchRobots() -> [Robot]?
    func addRobot(name: String, strategy: Strategy, config: IStrategyConfig) -> Robot?
    func deleteRobot(id: String)

    // MARK: Deals
    
    func fetchDeals(robotId: String) -> [Deal]
    func addDeal(_ deal: Deal)
    
    // MARK: Accounts
    
    func fetchAccounts() -> [AccountModel]
    func fetchAccount(id: String) -> AccountModel?
    func updateAccount(id: String, name: String?)
}
