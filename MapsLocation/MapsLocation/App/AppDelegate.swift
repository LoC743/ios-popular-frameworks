//
//  AppDelegate.swift
//  MapsLocation
//
//  Created by Alexey on 18.08.2021.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var notificationManager: NotificationManager?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(StringResources.apiKey)
        
        requestNotificationAuthorization()
        notificationManager = NotificationManager()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let authController = AuthBuilder.build()
        window.rootViewController = authController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true) {
            guard animated, let window = self.window else {
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
                return
            }
            
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    
    func applicationWillTerminate(_ application: UIApplication) {
        notificationManager?.sendTestNotification()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        notificationManager?.sendTestNotification()
    }
    
    // MARK: - Private
    
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Разрешение получено.")
            } else {
                print("Разрешение не получено.")
            }
        }
    }
}
