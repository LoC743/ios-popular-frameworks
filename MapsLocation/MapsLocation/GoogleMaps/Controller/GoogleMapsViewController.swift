//
//  GoogleMapsViewController.swift
//  MapsLocation
//
//  Created by Alexey on 18.08.2021.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var googleMapsView: GoogleMapsView {
        return self.view as! GoogleMapsView
    }
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = GoogleMapsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleMapsView.mapView.delegate = self
        locationManager.delegate = self
        
        checkLocationStatus()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    private func showSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }

    private func checkLocationStatus() {
        let locationStatus = locationManager.authorizationStatus
        
        switch locationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showSettings()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError()
        }
    }
}

extension GoogleMapsViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            googleMapsView.moveToPosition(with: lastLocation.coordinate)
            googleMapsView.addMarker(at: lastLocation.coordinate)
        }
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate {}
