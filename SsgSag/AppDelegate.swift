//
//  AppDelegate.swift
//  SsgSag
//
//  Created by admin on 24/12/2018.
//  Copyright © 2018 wndzlf. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var nav: UINavigationController?
    
    let swipeStoryBoard2 = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
    
    
    var controller: SLPagingViewSwift!
    
        // Override point for customization after application launch.
//        let loginVC = LoginVC()
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = loginVC
//        self.window?.makeKeyAndVisible()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let orange = UIColor(red: 255/255, green: 69.0/255, blue: 0.0/255, alpha: 1.0)
        let gray = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
        
        let myPageStoryBoard = UIStoryboard(name: "myPageStoryBoard", bundle: nil)
        let ctr1 = myPageStoryBoard.instantiateViewController(withIdentifier: "myPage")
        
        let swipeStoryBoard = UIStoryboard(name: "SwipeStoryBoard", bundle: nil)
        let ctr2 = swipeStoryBoard.instantiateViewController(withIdentifier: "Swipe") as! SwipeVC
        print(ctr2.valueArray.count)
        
        let ctr3 = CalenderVC()
        
        var img1 = #imageLiteral(resourceName: "btSignupPlus")
        img1 = img1.withRenderingMode(.alwaysTemplate)
        var img2 = #imageLiteral(resourceName: "btSignupPlus")
        img2 = img2.withRenderingMode(.alwaysTemplate)
        var img3 = #imageLiteral(resourceName: "btSignupPlus")
        img3 = img3.withRenderingMode(.alwaysTemplate)
        
        
        let items = [UIImageView(image: img1), UIImageView(image: img2), UIImageView(image: img3)]
        
        
        
        print("ctr2.allCardsArray.count \(ctr2.valueArray.count)")
        print("가나다라마바사 \(ctr2.abcde)")
        print(ctr2.view)
        print(ctr2.viewWillAppear(true))
        print("아자차카타파하 \(ctr2.abcde)")
        
        let controllers = [ctr1, ctr2, ctr3]
        
        controller = SLPagingViewSwift(items: items, controllers: controllers, showPageControl: false)
        
        controller.pagingViewMoving = ({ subviews in
            if let imageViews = subviews as? [UIImageView] {
                for imgView in imageViews {
//                    var c = gray
//                    let originX = Double(imgView.frame.origin.x)
//
//                    if (originX > 45 && originX < 145) {
//                        //c = self.gradient(originX, topX: 46, bottomX: 144, initC: orange, goal: gray)
//                    }
//                    else if (originX > 145 && originX < 245) {
//                        //c = self.gradient(originX, topX: 146, bottomX: 244, initC: gray, goal: orange)
//                    }
//                    else if(originX == 145){
//                        c = orange
//                    }
//                    imgView.tintColor = c
                }
            }
        })
        
        
        self.nav = UINavigationController(rootViewController: self.controller)
        self.window?.rootViewController = self.nav
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SsgSag")
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

