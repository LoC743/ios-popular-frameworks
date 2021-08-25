//
//  Location.swift
//  MapsLocation
//
//  Created by Alexey on 23.08.2021.
//

import RealmSwift
import CoreLocation

class Location: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        
        self.latitude = latitude
        self.longitude = longitude
    }
}
