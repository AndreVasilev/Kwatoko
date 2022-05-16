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
        let container = NSPersistentContainer(name: "Kwatoko")
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
