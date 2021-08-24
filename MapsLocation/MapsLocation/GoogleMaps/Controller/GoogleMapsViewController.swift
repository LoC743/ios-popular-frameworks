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
    
    private var isTracking = false {
        didSet {
            if isTracking {
                locationManager.startUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
                resetRouteLine()
            } else {
                locationManager.stopUpdatingLocation()
                locationManager.stopMonitoringSignificantLocationChanges()
                saveRoute()
            }
        }
    }
    
    private var routePath: GMSMutablePath?
    private var route: GMSPolyline?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = GoogleMapsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleMapsView.mapView.delegate = self
        
        setupLocationManager()
        addManageTackStatusButton()
        addShowLastRouteButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        googleMapsView.moveToUserPosition(animated: true)
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    private func setupRouteLine() {
        route?.strokeColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        route?.strokeWidth = 5
        route?.map = googleMapsView.mapView
    }
    
    private func resetRouteLine() {
        route?.map = nil
        routePath = GMSMutablePath()
        route = GMSPolyline(path: routePath)
        setupRouteLine()
    }
    
    private func addRouteCoordinate(_ coordinate: CLLocationCoordinate2D) {
        routePath?.add(coordinate)
        route?.path = routePath
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
    
    private func addShowLastRouteButton() {
        let barButton = UIBarButtonItem(title: StringResources.lastRouteTitle,
                                      style: .plain,
                                      target: self,
                                      action: #selector(handleShowLastRoute)
        )
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc private func handleShowLastRoute() {
        if isTracking {
            let yesAction = UIAlertAction(title: StringResources.yes, style: .default) { [weak self] _ in
                self?.handleTracking()
                self?.loadLastRoute()
            }
            let noAction = UIAlertAction(title: StringResources.no, style: .cancel)
            showAlert(with: StringResources.showLastRouteAlertTitle,
                      message: StringResources.showLastRouteAlertMessage,
                      actions: [noAction, yesAction]
            )
        } else {
            loadLastRoute()
        }
    }
    
    func loadLastRoute() {
        let locations = RouteStorage.shared.loadLastRoute()
        
        resetRouteLine()
        for location in locations {
            addRouteCoordinate(location.coordinate)
        }
        
        if let path = route?.path {
            let bounds = GMSCoordinateBounds(path: path)
            googleMapsView.showLastRoute(with: bounds)
        }
    }
    
    func saveRoute() {
        guard let path = route?.path else { return }
    
        var coordinates = [Location]()
        for index in 0..<path.count() {
            let coordinate = path.coordinate(at: index)
            let location = Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
            coordinates.append(location)
        }
        
        RouteStorage.shared.saveLastRoute(route: coordinates)
    }
    
    @objc private func handleTracking() {
        checkLocationStatus()
        
        isTracking.toggle()
        self.navigationItem.rightBarButtonItem?.title = isTracking ?
            StringResources.endTrackTitle : StringResources.startTrackTitle
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
        if isTracking,
           let lastLocation = locations.last {
            googleMapsView.moveToPosition(with: lastLocation.coordinate, animated: true)
            addRouteCoordinate(lastLocation.coordinate)
        }
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate {}
