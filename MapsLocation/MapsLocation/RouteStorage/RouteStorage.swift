//
//  RouteStorage.swift
//  MapsLocation
//
//  Created by Alexey on 23.08.2021.
//

import RealmSwift

class RouteStorage {
    static var shared = RouteStorage()
    
    private var realm = try! Realm()
    
    private init() {  }
    
    // MARK: - Saving data
    
    func saveLastRoute(route: [Location]) {
        clearLastRoute()
        try? realm.write {
            realm.add(route)
        }
    }
    
    // MARK: - Loading data
    
    func loadLastRoute() -> Results<Location> {
        return realm.objects(Location.self)
    }
    
    // MARK: - Remove all data
    
    func clearLastRoute() {
        let result = realm.objects(Location.self)
        try? realm.write {
            realm.delete(result)
        }
    }
}
