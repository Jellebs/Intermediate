//
//  AppDelegate.swift
//  myFavoriteSongs
//
//  Created by Jesper Bertelsen on 07/04/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var dataImporter: DataImporter!
    var persistenceCoordinator: PersistenceCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configurePersistenceCoordinator()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
// MARK:- CoreData
    
    func configurePersistenceCoordinator() {
        let applicationSupportUrl = FileManager.default.urls(for:
                                                                .applicationSupportDirectory, in: .userDomainMask).first
        let dataBasePath = applicationSupportUrl?.appendingPathComponent("Database")
        let description  = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
        description.url  = dataBasePath
        
        let bundle = Bundle(for: AppDelegate.self)
        
        guard let url = bundle.url(forResource: "myFavoriteSongs", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            print("Failed to construct the managed object model.")
            return
        }
        persistenceCoordinator = PersistenceCoordinator(model: model,
                                                        storeDescription: description)
        
//      MARK:- Uncomment to setup dataImporter for preloaded files.
//        dataImporter = DataImporter(persistenceCoordinator: persistenceCoordinator,
//                                    preloadedFileName: )
        
        persistenceCoordinator.constructCoreDataStack { /*[weak self]*/ constructException in
            if let constructionException = constructException {
                print("Failed to construct the core data stack:\(constructionException.localizedDescription)")
            } /* else if let strongSelf = self, !strongself.dataImporter.hasCompletedLocalDataImport() {
                strongself.preloadedCache(using: strongself.persistenceCoordinator) */
            }
        }
    func preloadedCache(using persistenceCoordinator: PersistenceCoordinator) {
        
        dataImporter.importPreloadedData { importError in
            if let importError = importError {
                print("Failed to import cached data with error at: \(importError.localizedDescription)")
                
            } else {
                
                print("Successfully implemented cached data")
            }
        }
    }
}


