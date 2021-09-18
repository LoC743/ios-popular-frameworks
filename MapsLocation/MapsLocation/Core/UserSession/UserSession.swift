//
//  UserSession.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import Foundation

final class UserSession {
    
    static var shared = UserSession()
    
    private init() { }
    
    public var username: String?
}
