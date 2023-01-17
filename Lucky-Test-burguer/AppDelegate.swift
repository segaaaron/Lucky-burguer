//
//  AppDelegate.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        if #available(iOS 13.0, *) {} else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            let viewModel = HomeViewModel()
            let home = HomeViewController(viewModel: viewModel)
            let controller = UINavigationController(rootViewController: home)
            self.window = window
            self.window?.rootViewController = controller
        }
        
        return true
     }
    
    // MARK: IOS 12 DELEGATE Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {} else {
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Not called under iOS 13 - See SceneDelegate sceneWillResignActive
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Not called under iOS 13 - See SceneDelegate sceneDidEnterBackground
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Not called under iOS 13 - See SceneDelegate sceneWillEnterForeground
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Not called under iOS 13 - See SceneDelegate sceneDidBecomeActive
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
