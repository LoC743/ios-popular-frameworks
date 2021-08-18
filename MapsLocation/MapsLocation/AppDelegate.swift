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
        
        GMSServices.provideAPIKey("AIzaSyBjkVttiUTLeAM4Sl6SJLic0BUQGZMu6g4")
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = GoogleMapsViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

