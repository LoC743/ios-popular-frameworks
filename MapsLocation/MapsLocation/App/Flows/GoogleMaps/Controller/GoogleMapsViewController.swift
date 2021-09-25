 //
//  GoogleMapsViewController.swift
//  MapsLocation
//
//  Created by Alexey on 18.08.2021.
//

import UIKit
import GoogleMaps
import RxSwift

 class GoogleMapsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var googleMapsView: GoogleMapsView {
        return self.view as! GoogleMapsView
    }
    
    private let locationManager = LocationManager()
    
    private let disposeBag = DisposeBag()
    
    private var isTracking = false {
        didSet {
            if isTracking {
                locationManager.startUpdatingLocation()
                resetRouteLine()
            } else {
                locationManager.stopUpdatingLocation()
                saveRoute()
            }
        }
    }
    
    private var routePath: GMSMutablePath?
    private var route: GMSPolyline?
    private var markerImage: UIImage? {
        didSet {
            guard let username = UserSession.shared.username,
                  let image = markerImage else {
                return
            }
            UserStorage.shared.saveCustomMarker(image, for: username)
        }
    }
    
    private let presenter: GoogleMapsViewOutput
    
    // MARK: - Lifecycle
    
    init(presenter: GoogleMapsViewOutput) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        loadCustomMarker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = GoogleMapsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleMapsView.mapView.delegate = self
        
        setupLocationManager()
        addManageTackStatusButton()
        let leftBarButtons = [addShowLastRouteButton(),
                              addTakePhotoForMarker()]
        navigationItem.leftBarButtonItems = leftBarButtons
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        googleMapsView.moveToUserPosition(animated: true)
    }
    
    private func loadCustomMarker() {
        guard let username = UserSession.shared.username,
              let image = UserStorage.shared.loadCustomMarker(for: username) else { return }
        self.markerImage = image
    }
    
    private func setupRouteLine() {
        route?.strokeColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        route?.strokeWidth = 5
        route?.map = googleMapsView.mapView
    }
    
    private func setupLocationManager() {
        _ = locationManager.authrizationStaus.subscribe(onNext: { [weak self] status in
            switch status {
            case .notDetermined:
                self?.locationManager.requestAuthorizationAccess()
            case .restricted, .denied:
                self?.showSettings()
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                fatalError()
            }
        })
        .disposed(by: disposeBag)
        
        _ = locationManager.userLocation.subscribe(onNext: { [weak self] location in
            self?.updateUserLocation(location)
        })
        .disposed(by: disposeBag)
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
    
    private func addShowLastRouteButton() -> UIBarButtonItem  {
        let barButton = UIBarButtonItem(title: StringResources.lastRouteTitle,
                                      style: .plain,
                                      target: self,
                                      action: #selector(handleShowLastRoute))
        return barButton
    }
    
    private func addTakePhotoForMarker() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "camera"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(handleTakePhoto))
       return barButton
    }
    
    private func handleStopTracking(action: UIAlertAction) {
        handleTracking()
        loadLastRoute()
    }
    
    @objc private func handleTakePhoto() {
        presentPickerController()
    }
    
    @objc private func handleShowLastRoute() {
        if isTracking {
            presenter.viewDidShowAlert(with: handleStopTracking(action:))
        } else {
            loadLastRoute()
        }
    }
    
    @objc private func handleTracking() {
        isTracking.toggle()
        self.navigationItem.rightBarButtonItem?.title = isTracking ?
            StringResources.endTrackTitle : StringResources.startTrackTitle
    }

    private func updateUserLocation(_ location: CLLocation) {
        googleMapsView.moveToPosition(with: location.coordinate, animated: true)
        googleMapsView.setMarker(at: location.coordinate, image: markerImage)
        addRouteCoordinate(location.coordinate)
    }
    
    private func saveRoute() {
        guard let path = route?.path else { return }
        
        presenter.saveRoute(with: path)
    }
    
    private func loadLastRoute() {
        presenter.loadLastRoute()
    }
    
    public func setRoute(with locations: [Location]) {
        resetRouteLine()
        for location in locations {
            addRouteCoordinate(location.coordinate)
        }

        if let path = route?.path {
            let bounds = GMSCoordinateBounds(path: path)
            googleMapsView.showLastRoute(with: bounds)
        }
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate { }

extension GoogleMapsViewController: GoogleMapsViewInput { }

extension GoogleMapsViewController: UINavigationControllerDelegate { }
 
extension GoogleMapsViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = extractImage(from: info) {
            markerImage = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func extractImage(from info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let image = info[.editedImage] as? UIImage {
            return image
        }
        
        if let image = info[.originalImage] as? UIImage {
            return image
        }
        
        return nil
    }
    
    func presentPickerController() {
//        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
//        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        pickerController.delegate = self

        present(pickerController, animated: true, completion: nil)
    }
}
