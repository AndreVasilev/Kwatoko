//
//  DatabaseService.swift
//
//  Created by Andrey Vasilev on 07.12.2020.
//

import Foundation
import CoreData

class DatabaseService {

    // MARK: - Core Data stack

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TinkoffContestKwatoko")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

            if let error = error as NSError? {
                print("⚠️ Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

// MARK: Profile

extension DatabaseService: IDatabaseService {

    var profile: ProfileEntity? {
        do {
            let request = ProfileEntity.fetchRequest()
            let profiles = try persistentContainer.viewContext.fetch(request)
            return profiles.first
        } catch {
            print(error)
            return nil
        }
    }

    func updateProfile(token: String, sandboxToken: String, accountId: String?) {
        if let entity = profile {
            entity.token = token
            entity.sandboxToken = sandboxToken
            entity.selectedAccountId = accountId
            saveContext()
        } else {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileEntity")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try persistentContainer.viewContext.execute(deleteRequest)

                let entity = ProfileEntity(context: persistentContainer.viewContext)
                entity.token = token
                entity.sandboxToken = sandboxToken
                entity.selectedAccountId = accountId
                saveContext()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: Robots

extension DatabaseService {

    func addRobot(name: String, strategy: Strategy, config: IStrategyConfig) -> Robot? {
        switch strategy {
        case .contest:
            guard let config = config as? ContestStrategy.Config else { return nil }
            return addRobot(name: name, contestStrategy: strategy, config: config)
        }
    }

    func fetchRobots() -> [Robot]? {
        do {
            let request = RobotEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
            let robotEntities = try persistentContainer.viewContext.fetch(request)
            return robotEntities.compactMap { Robot($0) }
        } catch {
            print(error)
            return nil
        }
    }

    func fetchRobot(id: String) -> Robot? {
        do {
            let request = RobotEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            request.fetchLimit = 1
            guard let entity = try persistentContainer.viewContext.fetch(request).first else { return nil }
            return Robot(entity)
        } catch {
            print(error)
            return nil
        }
    }

    func deleteRobot(id: String, configId: String) {
        do {
            try deleteEntity("ContestStrategyConfigEntity", id: configId)
            try deleteEntity("RobotEntity", id: id)
        } catch {
            print(error)
        }
    }

    private func addRobot(name: String, contestStrategy strategy: Strategy, config: ContestStrategy.Config) -> Robot? {
        let configEntity = ContestStrategyConfigEntity(context: persistentContainer.viewContext)
        configEntity.id = config.id
        configEntity.accountID = config.accountID
        configEntity.figi = config.figi
        configEntity.currency = config.currency.rawValue
        configEntity.depth = Int16(config.depth)
        configEntity.orderDirection = Int16(config.orderDirection.rawValue)
        configEntity.edgeQuantity = config.edgeQuantity
        configEntity.orderQuantity = config.orderQuantity
        configEntity.orderDelta = NSDecimalNumber(decimal: config.orderDelta)
        configEntity.stopLossPercent = config.stopLossPercent
        configEntity.takeProfitPercent = config.takeProfitPercent

        let robotEntity = RobotEntity(context: persistentContainer.viewContext)
        robotEntity.id = UUID().uuidString
        robotEntity.name = name
        robotEntity.strategy = strategy.rawValue
        robotEntity.config = configEntity
        robotEntity.created = Date()
        saveContext()

        return Robot(robotEntity)
    }
}

// MARK: Deals

extension DatabaseService {

    func fetchDeals(robotId: String) -> [Deal] {
        let currency = fetchRobot(id: robotId)?.config.currencyValue ?? "rub"
        return Deal.demoList(robotId: robotId, currency: currency)
    }

    func addDeal(_ deal: Deal) {
        
    }
}

// MARK: Private

private extension DatabaseService {

    func deleteEntity(_ name: String, id: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try persistentContainer.viewContext.execute(deleteRequest)
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("⚠️ Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
