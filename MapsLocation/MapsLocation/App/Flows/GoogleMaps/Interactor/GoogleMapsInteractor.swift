//
//  GoogleMapsInteractor.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import Foundation

protocol GoogleMapsInteractorInput {
    func saveRouteToRealm(locations: [Location])
    func loadLastRoute() -> [Location]
}

class GoogleMapsInteractor: GoogleMapsInteractorInput {
    
    func saveRouteToRealm(locations: [Location]) {
        guard let username = UserSession.shared.username else { return }
        RouteStorage.shared.saveLastRoute(route: locations, owner: username)
    }
    
    func loadLastRoute() -> [Location] {
        guard let username = UserSession.shared.username else { return [] }
        let resultLocations = RouteStorage.shared.loadLastRoute(for: username)
        
        return resultLocations.map { $0 }
    }
}
