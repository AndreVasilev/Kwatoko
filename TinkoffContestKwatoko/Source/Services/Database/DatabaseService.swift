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

    var profile: Profile? {
        guard let entity = profileEntity,
              let token = entity.token,
              let sandboxToken = entity.sandboxToken
        else { return nil }

        return Profile(token: token,
                       sandboxToken: sandboxToken,
                       selectedAccountId: entity.selectedAccountId)
    }

    private var profileEntity: ProfileEntity? {
        do {
            let request = ProfileEntity.fetchRequest()
            let entities = try persistentContainer.viewContext.fetch(request)
            return entities.first
        } catch {
            print(error)
            return nil
        }
    }

    func updateProfile(token: String, sandboxToken: String, accountId: String?) {
        do {
            if let entity = profileEntity {
                entity.token = token
                entity.sandboxToken = sandboxToken
                entity.selectedAccountId = accountId
            } else {
                try deleteAll(entity: "ProfileEntity")

                let entity = ProfileEntity(context: persistentContainer.viewContext)
                entity.token = token
                entity.sandboxToken = sandboxToken
                entity.selectedAccountId = accountId
            }
            try saveContext()
        } catch {
            let nserror = error as NSError
            print("⚠️ Unresolved error \(nserror), \(nserror.userInfo)")
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

    func deleteRobot(id: String) {
        do {
            try deleteEntity("RobotEntity", id: id)
            try saveContext()
        } catch {
            print(error)
        }
    }

    private func addRobot(name: String, contestStrategy strategy: Strategy, config: ContestStrategy.Config) -> Robot? {

        let robotEntity = RobotEntity(context: persistentContainer.viewContext)
        robotEntity.id = UUID().uuidString
        robotEntity.name = name
        robotEntity.strategy = strategy.rawValue
        robotEntity.config = ContestStrategyConfigEntity(config: config, context: persistentContainer.viewContext)
        robotEntity.created = Date()

        do {
            try saveContext()
            return Robot(robotEntity)
        } catch {
            let nserror = error as NSError
            print("⚠️ Unresolved error \(nserror), \(nserror.userInfo)")
            return nil
        }
    }
}

// MARK: Deals

extension DatabaseService {

    func fetchDeals(robotId: String) -> [Deal] {
//        let currency = fetchRobot(id: robotId)?.config.instrument.currency ?? "rub"
//        return Deal.demoList(robotId: robotId, currency: currency)

        do {
            let request = DealEntity.fetchRequest()
            request.predicate = NSPredicate(format: "robotId == %@", robotId)
            let entities = try persistentContainer.viewContext.fetch(request)
            return entities
                .compactMap { Deal($0) }
                .sorted(by: { $1.date < $0.date })
        } catch {
            let nserror = error as NSError
            print("⚠️ Unresolved error \(nserror), \(nserror.userInfo)")
            return []
        }
    }

    func addDeal(_ deal: Deal) {
        do {
            _ = DealEntity(deal: deal, context: persistentContainer.viewContext)
            try saveContext()
        } catch {
            let nserror = error as NSError
            print("⚠️ Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

// MARK: Private

private extension DatabaseService {

    func deleteAll(entity name: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try persistentContainer.viewContext.execute(deleteRequest)
    }

    func deleteEntity(_ name: String, id: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try persistentContainer.viewContext.execute(deleteRequest)
    }

    // MARK: - Core Data Saving support

    func saveContext () throws {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        try context.save()
    }
}
