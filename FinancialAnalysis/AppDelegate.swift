//
//  AppDelegate.swift
//  FinancialAnalysis
//
//  Created by Евгения Головкина on 08.10.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController = UITabBarController()
    var CostsNavigationController = UINavigationController()
    var GraphNavigationController = UINavigationController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // установка элементов модуля главного экрана
        let interactorCosts = CostsInteractor()
        let presenterCosts = CostsPresenter()
        let routerCosts = CostsRouter()
        
        presenterCosts.interactor = interactorCosts
        presenterCosts.router = routerCosts
        
        let rootViewCosts = CostsViewController()
        rootViewCosts.presenter = presenterCosts
        
        CostsNavigationController = UINavigationController(rootViewController: rootViewCosts)
        
        let interactorGraph = GraphInteractor()
        let presenterGraph = GraphPresenter()
        let routerGraph = GraphRouter()
        
        presenterGraph.interactor = interactorGraph
        presenterGraph.router = routerGraph
        
        let rootViewGraph = GraphViewController()
        rootViewGraph.presenter = presenterGraph
        
        GraphNavigationController = UINavigationController(rootViewController: rootViewGraph)
        
        tabBarController.viewControllers = [CostsNavigationController, GraphNavigationController]
        
        tabBarController.tabBar.layer.borderWidth = 0.50
        tabBarController.tabBar.layer.borderColor = UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor
        
        CostsNavigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        CostsNavigationController.navigationBar.shadowImage = UIImage()
        
        GraphNavigationController.tabBarItem = .init(title: "График", image: UIImage(systemName: "circle"), tag: 1)
        CostsNavigationController.tabBarItem = .init(title: "Расходы", image: UIImage(systemName: "circle"), tag: 0)
        
        window?.rootViewController = tabBarController
        
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FinancialAnalysis")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

