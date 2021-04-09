//
//  PersistenceCoordinator.swift
//  myFavoriteSongs
//
//  Created by Jesper Bertelsen on 07/04/2021.
//

import Foundation
import CoreData

class PersistenceCoordinator {
    
    typealias completionHandler = (Error?) -> Void
    typealias fetchedResultHandler = ([NSManagedObject]?, Error?) -> Void
    
    let persistentContainer: NSPersistentContainer
    let model: NSManagedObjectModel
    
    var fetchContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    var privateContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.model = persistentContainer.managedObjectModel
    }
    init(model: NSManagedObjectModel, storeDescription: NSPersistentStoreDescription) {
        self.model = model
        self.persistentContainer = NSPersistentContainer(name: "", managedObjectModel: model)
        self.persistentContainer.persistentStoreDescriptions = [storeDescription]
    }
    
    func constructCoreDataStack(_ completionHandler: @escaping completionHandler) {
        var loadedStoresCount = 0
        let storesToLoad = persistentContainer.persistentStoreDescriptions.count
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let err = error {
                print("The load called failed:\(err.localizedDescription)")
                completionHandler(error)
                return
            }
            loadedStoresCount+=1
            
            if loadedStoresCount == storesToLoad {
                completionHandler(nil)
            }
        }
    }
    func saveChanges(in context: NSManagedObjectContext, completionHandler: @escaping completionHandler) {
        context.perform {
            do {
                if context.hasChanges {
                    try context.save()
                    try context.parent?.save()
                }
                completionHandler(nil)
            } catch {
                print("Hit an error while saving context at:\(error.localizedDescription)")
                completionHandler(error)
            }
        }
    }
    func fetch(from context: NSManagedObjectContext, fetchRequest: NSFetchRequest<NSFetchRequestResult>, fetchCompletionHandler: fetchedResultHandler) {
        do {
            let fetchedResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            fetchCompletionHandler(fetchedResults, nil)
        } catch {
            print("hit an error:\(error.localizedDescription)")
            fetchCompletionHandler(nil, error)
        }
    }
    func delete(managedObjects: [NSManagedObject], completionHandler: @escaping completionHandler) {
        do {
            for i in 0..<managedObjects.count {
                if let context = managedObjects[i].managedObjectContext {
                    context.delete(managedObjects[i])
                    try context.save()
                    try context.parent?.save()
                }
            }
            completionHandler(nil)
        } catch {
            print(error.localizedDescription)
            completionHandler(error)
        }
    }
}
