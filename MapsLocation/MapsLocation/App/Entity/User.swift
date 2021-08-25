//
//  User.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import Foundation

import RealmSwift

class User: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    
    override class func primaryKey() -> String? {
        return "login"
    }

    convenience init(login: String, password: String) {
        self.init()
        
        self.login = login
        self.password = password
    }
}
