//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 21/02/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let rootAssembly = RootAssembly()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = UINavigationController(rootViewController: rootAssembly.presentationAssembly.conversationListViewController())
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        printAppState("Application moved from \"Not running\" to \"Foreground(Inactive)\": \(#function)")
        
        //ДЗ №4. 10 пункт:
        appInitialSetup()
        
        return true
    }
    
    private func appInitialSetup() {
        if let color = UserDefaults.standard.loadAppTheme() {
            UINavigationBar.appearance().backgroundColor = color
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        printAppState("Application will be moved from \"Foreground(Active)\" to \"Foreground(Inactive)\": \(#function)")

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        printAppState("Application moved from \"Foreground(Inactive)\" to \"Background\": \(#function)")
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        printAppState("Application will be moved from \"Background\" to \"Foreground\": \(#function)\n P.S.: Documentation says: The call to this method is invariably followed by a call to the applicationDidBecomeActive(_:) method, which then moves the app from the inactive to the active state.")

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        printAppState("Application moved from \"Foreground(Inactive)\" to \"Foreground(Active)\": \(#function)")
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

        printAppState("Application will moved from \"Background\" to \"Suspended\" and then to \"Not running\": \(#function)")

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func printAppState(_ text: String) {
        print(text)
    }
}

