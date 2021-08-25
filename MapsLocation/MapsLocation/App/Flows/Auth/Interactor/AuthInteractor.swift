//
//  AuthInteractor.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import Foundation

protocol AuthInteractorInput {
    func signIn(user: User) -> Bool
    func signUp(user: User) -> Bool
}

class AuthInteractor: AuthInteractorInput {
    
    func signIn(user: User) -> Bool {
        return UserStorage.shared.isUserExist(user: user)
    }
    
    func signUp(user: User) -> Bool {
        return UserStorage.shared.addUser(user)
    }
}
