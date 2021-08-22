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
    
    private var isTracking = false
    
    private var routePath = GMSMutablePath()
    private lazy var route: GMSPolyline = {
        return GMSPolyline(path: routePath)
    }()
        
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = GoogleMapsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleMapsView.mapView.delegate = self
        
        setupLocationManager()
        setupRouteLine()
        addManageTackStatusButton()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    private func setupRouteLine() {
        route.strokeColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        route.strokeWidth = 5
        route.map = googleMapsView.mapView
    }
    
    private func resetRouteLine() {
        route.map = nil
        routePath = GMSMutablePath()
        route = GMSPolyline(path: routePath)
        setupRouteLine()
    }
    
    private func addRouteCoordinate(_ coordinate: CLLocationCoordinate2D) {
        routePath.add(coordinate)
        route.path = routePath
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
    
    private func addManageTackStatusButton() {
        let barButton = UIBarButtonItem(title: StringResources.startTrackTitle,
                                      style: .plain,
                                      target: self,
                                      action: #selector(handleTracking)
        )
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func handleTracking() {
        checkLocationStatus()
        
        isTracking.toggle()
        self.navigationItem.rightBarButtonItem?.title = isTracking ?
            StringResources.endTrackTitle : StringResources.startTrackTitle
        
        if isTracking {
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        } else {
            locationManager.stopUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
            resetRouteLine()
        }
    }

    private func checkLocationStatus() {
        let locationStatus = locationManager.authorizationStatus
        
        switch locationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            showSettings()
        case .authorizedAlways, .authorizedWhenInUse:
            break
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
            addRouteCoordinate(lastLocation.coordinate)
//            googleMapsView.addMarker(at: lastLocation.coordinate)
        }
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate {}
