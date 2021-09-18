//
//  UserStorage.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import RealmSwift

class UserStorage {
    static var shared = UserStorage()
    
    private var realm = try! Realm()
    
    private init() {  }
    
    // MARK: - Saving data
    
    public func addUser(_ user: User) -> Bool {
        if isUserExist(user: user) {
            return false
        } else {
            createUser(user)
            return true
        }
    }
    
    private func createUser(_ user: User) {
        try? realm.write {
            realm.add(user)
        }
    }
    
    // MARK: - isUserExist
    
    func isUserExist(user: User) -> Bool {
        guard let databaseUser = realm.object(ofType: User.self, forPrimaryKey: user.login) else { return false }
        
        if user.password == databaseUser.password {
            return true
        } else {
            return false
        }
    }
    
}
