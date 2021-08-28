//
//  AuthPresenter.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import UIKit

protocol AuthViewInput: AnyObject { }

protocol AuthViewOutput {
    func viewDidSignIn(username: String, password: String)
    func viewHaveEmptyFields()
    func viewDidSignUp(username: String, password: String)
}

class AuthPresenter {
    let interactor: AuthInteractorInput
    let router: AuthRouterInput
    
    weak var viewInput: (UIViewController & AuthViewInput)?
    
    init(interactor: AuthInteractorInput, router: AuthRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension AuthPresenter: AuthViewOutput {
    func viewDidSignIn(username: String, password: String) {
        let user = User(login: username, password: password)
        
        if interactor.signIn(user: user) {
            UserSession.shared.username = username
            router.moveToMainViewController()
        } else {
            router.showUserDoesntExistError()
        }
    }
    
    func viewHaveEmptyFields() {
        router.showEmptyFieldsError()
    }
    
    func viewDidSignUp(username: String, password: String) {
        let user = User(login: username, password: password)
        
        if interactor.signUp(user: user) {
            UserSession.shared.username = username
            router.moveToMainViewController()
        } else {
            router.showUserIsAlreadyExists()
        }
    }
}
