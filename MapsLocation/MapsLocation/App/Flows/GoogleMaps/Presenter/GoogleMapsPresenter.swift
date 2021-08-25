//
//  GoogleMapsPresenter.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import UIKit
import GoogleMaps

protocol GoogleMapsViewInput: AnyObject {
    func setRoute(with locations: [Location])
}

protocol GoogleMapsViewOutput {
    func saveRoute(with path: GMSPath)
    func loadLastRoute()
    func viewDidShowAlert(with handler: ((UIAlertAction) -> Void)?)
}

class GoogleMapsPresenter {
    let interactor: GoogleMapsInteractorInput
    let router: GoogleMapsRouterInput
    
    weak var viewInput: (UIViewController & GoogleMapsViewInput)?
    
    
    init(interactor: GoogleMapsInteractorInput, router: GoogleMapsRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
}

extension GoogleMapsPresenter: GoogleMapsViewOutput {
    
    func saveRoute(with path: GMSPath) {
        guard let username = UserSession.shared.username else { return }
        var coordinates = [Location]()
        for index in 0..<path.count() {
            let coordinate = path.coordinate(at: index)
            let location = Location(latitude: coordinate.latitude, longitude: coordinate.longitude, owner: username)
            coordinates.append(location)
        }
        
        interactor.saveRouteToRealm(locations: coordinates)
    }
    
    func loadLastRoute() {
        let locations = interactor.loadLastRoute()
        
        viewInput?.setRoute(with: locations)
    }
    
    func viewDidShowAlert(with handler: ((UIAlertAction) -> Void)?) {
        let yesAction = UIAlertAction(title: StringResources.yes, style: .default, handler: handler)
        router.showStopWarningAlert(with: yesAction)
    }
    
}
