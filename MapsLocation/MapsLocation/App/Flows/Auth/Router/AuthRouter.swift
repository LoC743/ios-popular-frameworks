//
//  AuthRouter.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import UIKit

protocol AuthRouterInput {
    func showUserDoesntExistError()
    func showUserIsAlreadyExists()
    func showEmptyFieldsError()
    func moveToMainViewController()
}

class AuthRouter: AuthRouterInput {
    
    weak var viewController: UIViewController?
    
    func showUserDoesntExistError() {
        let action: UIAlertAction = UIAlertAction(
            title: StringResources.ok,
            style: .default,
            handler: nil
        )
        
        viewController?.showAlert(
            with: StringResources.userDoesNotExitsAlertTitle,
            message: StringResources.userDoesNotExistAlertMessage,
            actions: [action])
    }
    
    func showUserIsAlreadyExists() {
        let action: UIAlertAction = UIAlertAction(
            title: StringResources.ok,
            style: .default,
            handler: nil
        )
        
        viewController?.showAlert(
            with: StringResources.userAlreadyExistsAlertTitle,
            message: StringResources.userAlreadyExistsAlertMessage,
            actions: [action])
    }
    
    func showEmptyFieldsError() {
        let action: UIAlertAction = UIAlertAction(
            title: StringResources.ok,
            style: .default,
            handler: nil
        )
        
        viewController?.showAlert(
            with: StringResources.emptyFieldsAlertTitle,
            message: StringResources.emptyFieldsAlertMessage,
            actions: [action])
    }
    
    func moveToMainViewController() {
        let mainViewController = GoogleMapsBuilder.build()
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setRootViewController(mainViewController)
    }
}
