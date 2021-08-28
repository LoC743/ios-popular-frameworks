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

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(StringResources.apiKey)
        
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
}
