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
    
    func saveLastRoute(route: [Location], owner: String) {
        clearLastRoute(for: owner)
        try? realm.write {
            realm.add(route)
        }
    }
    
    // MARK: - Loading data
    
    func loadLastRoute(for owner: String) -> Results<Location> {
        return realm.objects(Location.self).filter("owner == '\(owner)'")
    }
    
    // MARK: - Remove all data
    
    func clearLastRoute(for owner: String) {
        let result = realm.objects(Location.self).filter("owner == '\(owner)'")
        try? realm.write {
            realm.delete(result)
        }
    }
}
