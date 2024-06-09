//
//  AppDelegate.swift
//  chamcong
//
//  Created by Quang Linh on 24/02/2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var orientationLock = UIInterfaceOrientationMask.all


    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
        }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // add network reachability observer on app start
        do {
                    try Network.reachability = Reachability(hostname: "www.google.com")
                }
                catch {
                    switch error as? Network.Error {
                    case let .failedToCreateWith(hostname)?:
                        print("Network error:\nFailed to create reachability object With host named:", hostname)
                    case let .failedToInitializeWith(address)?:
                        print("Network error:\nFailed to initialize reachability object With address:", address)
                    case .failedToSetCallout?:
                        print("Network error:\nFailed to set callout")
                    case .failedToSetDispatchQueue?:
                        print("Network error:\nFailed to set DispatchQueue")
                    case .none:
                        print(error)
                    }
                }
        return true
    }
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    


}

