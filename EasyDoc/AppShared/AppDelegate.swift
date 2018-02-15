//
//  AppDelegate.swift
//  EasyDoc
//
//  Created by Rodrigo Hilkner on 23/01/18.
//  Copyright © 2018 Rodrigo Hilkner. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Configuring Firebase database application
        FirebaseApp.configure()
        
        // Verifying if user is already logged in
        self.checkUserAlreadyLoggedIn()
        
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
    }


}

extension AppDelegate {
    
    /// Verifies if user is already logged into EasoDoc's Firebase Server.
    func checkUserAlreadyLoggedIn() {
        
        // Veryfying if user is logged into EasyDoc's Firebase Server
        guard let user = Auth.auth().currentUser else {
            self.setInitialViewController(withIdentifier: "LoginViewController")
            return
        }
        
        // Trying to get user email
        guard let userEmail = user.email else {
            print("-> WARNING: EasyDocOfflineError.foundNil @ AppDelegate.checkUserAlreadyLoggedIn()")
            self.setInitialViewController(withIdentifier: "LoginViewController")
            return
        }
        
        self.userIsLoggedIn(userEmail: userEmail)
        
        
        
//        Auth.auth().addStateDidChangeListener {
//            (_, user) in
//
//            guard let user = user else {
//                print("No user is signed in.")
//                return
//            }
//
//            guard let userEmail = user.email else {
//                print(EasyDocAuthError.unexpectedError.localizedDescription)
//                return
//            }
//
//            // Loading user object from database
//            AuthServices.loadUserObject(email: userEmail) {
//                (fetchingError) in
//
//                // Handling error
//                if let error = fetchingError {
//                    print(error.localizedDescription)
//
//                    AuthServices.attemptToLogout() {
//                        (logoutError) in
//
//                        if logoutError != nil {
//                            print(logoutError!.localizedDescription)
//                        }
//                    }
//                }
//
//                print("User \(userEmail) has logged in successfully.")
//            }
//        }
    }
    
    
    /// Loads user into the app.
    func userIsLoggedIn(userEmail: String) {
        
        // Setting initial view controller as main screen
        self.setInitialViewController(withIdentifier: "MainScreenViewController")
        
        // Loading user object from database
        FetchingServices.loadMainUser(email: userEmail) {
            (fetchingError) in
            
            // Handling error
            if fetchingError != nil {
                print("-> WARNING: EasyDocQueryError.loadMainUser @ AppDelegate.checkUserAlreadyLoggedIn()")
                
                AuthServices.attemptToLogout() {
                    (logoutError) in
                    
                    if logoutError != nil {
                        print("-> WARNING: EasyDocQueryError.logoutError @ AppDelegate.checkUserAlreadyLoggedIn()")
                    }
                }
            }
        }
    }
    
    
    /// Sets initial controller with given identifier.
    func setInitialViewController(withIdentifier identifier: String) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
}

