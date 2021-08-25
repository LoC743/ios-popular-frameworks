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
        RouteStorage.shared.saveLastRoute(route: locations)
    }
    
    func loadLastRoute() -> [Location] {
        let resultLocations = RouteStorage.shared.loadLastRoute()
        
        return resultLocations.map { $0 }
    }
}
