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

private extension DatabaseService {

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
