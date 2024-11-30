//
//  AppDelegate.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 25.11.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var dataLoader: DataLoader?
    private let todoStore = TodoStore()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let networkClient = NetworkClient()
        dataLoader = DataLoader(networkClient: networkClient, todoStore: todoStore)
        
        DispatchQueue.global(qos: .background).async {
            self.todoStore.removeAllData { [weak self] in
                guard let self else { return }
                self.dataLoader?.loadDataFromNetwork {
                    DispatchQueue.main.async {
                        self.notifyRootViewControllerToLoadData()
                    }
                }
            }
        }
        
        return true
    }
    
    private func notifyRootViewControllerToLoadData() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let navController = sceneDelegate.window?.rootViewController as? UINavigationController,
              let rootVC = navController.viewControllers.first as? ListViewController else {
            print("RootViewController is not of type ListViewController")
            return
        }
        
        rootVC.loadData()
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodosDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

