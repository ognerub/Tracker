//
//  AppDelegate.swift
//  Tracker
//
//  Created by Admin on 9/30/23.
//

import UIKit
import CoreData

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AnalyticsService.activate()
        DaysValueTransformer.register()
        UIColorValueTransformer.register()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        AnalyticsService().report(event: "open", params: ["screen": "Main"])
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        guard let lastViewController = UserDefaults.standard.string(forKey: "LastViewController") else { return }
        AnalyticsService().report(event: "close", params: ["screen": lastViewController == "TrackersListViewController" ? "Main" : lastViewController])
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        configuration.storyboard = nil
        configuration.sceneClass = UIWindowScene.self
        configuration.delegateClass = SceneDelegate.self
        
        applicationWillEnterForeground(application)
        
        return configuration
    }
    
    // MARK: - Core Data Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Presistent Container. Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("SaveContext. Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

