//
//  GoogleMapsBuilder.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import UIKit

class GoogleMapsBuilder {
    static func build() -> UINavigationController {
        let interactor = GoogleMapsInteractor()
        let router = GoogleMapsRouter()

        let presenter = GoogleMapsPresenter(interactor: interactor, router: router)
        
        let viewController = GoogleMapsViewController(presenter: presenter)
        presenter.viewInput = viewController
        router.viewController = viewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        return navigationController
    }
}
