//
//  LocationManager.swift
//  MapsLocation
//
//  Created by Alexey on 02.09.2021.
//

import CoreLocation
import RxSwift

final class LocationManager: NSObject {
    
    // MARK: - Observables
    
    let authrizationStaus: BehaviorSubject<CLAuthorizationStatus>
    
    let userLocation = PublishSubject<CLLocation>()
    
    // MARK: - Private properties
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Init
    
    override init() {
        self.authrizationStaus = BehaviorSubject(value: locationManager.authorizationStatus)
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    // MARK: - Public Methods
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func requestAuthorizationAccess() {
        locationManager.requestAlwaysAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authrizationStaus.onNext(manager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation.onNext(location)
        }
    }
}
