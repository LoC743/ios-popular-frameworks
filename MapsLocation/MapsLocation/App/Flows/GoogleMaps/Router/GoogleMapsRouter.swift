//
//  GoogleMapsRouter.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import UIKit

protocol GoogleMapsRouterInput {
    func showStopWarningAlert(with action: UIAlertAction)
}

class GoogleMapsRouter: GoogleMapsRouterInput {
    
    weak var viewController: UIViewController?
    
    func showStopWarningAlert(with action: UIAlertAction) {
        
        let noAction = UIAlertAction(title: StringResources.no, style: .cancel)
        viewController?.showAlert(with: StringResources.showLastRouteAlertTitle,
                  message: StringResources.showLastRouteAlertMessage,
                  actions: [noAction, action]
        )
    }
}
