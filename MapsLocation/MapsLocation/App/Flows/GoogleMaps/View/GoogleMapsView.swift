//
//  GoogleMapsView.swift
//  MapsLocation
//
//  Created by Alexey on 18.08.2021.
//

import SnapKit
import GoogleMaps

final class GoogleMapsView: UIView {
    // MARK: - Subviews
    
    lazy var mapView = GMSMapView()
    private var marker: GMSMarker?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - Constants
    
    enum Constants {
        static let safeArea = UIApplication.shared.windows[0].safeAreaInsets
        static let navigationBarHeight: CGFloat = 44.0
        
        static let sideOffset: CGFloat = 35.0
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .white
        
        setupMapView()
    }
    
    private func setupMapView() {
        addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        
        if let style = Bundle.main.url(forResource: StringResources.styleFileName,
                                       withExtension: StringResources.styleFileExtension) {
            mapView.mapStyle = try? GMSMapStyle(contentsOfFileURL: style)
        }
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func moveToPosition(with coordinate: CLLocationCoordinate2D, animated: Bool) {
        let position = GMSCameraPosition(target: coordinate, zoom: 17)
        
        if animated {
            mapView.animate(to: position)
        } else {
            mapView.camera = position
        }
    }
    
    func moveToUserPosition(animated: Bool) {
        if let coordinate = mapView.myLocation?.coordinate {
            moveToPosition(with: coordinate, animated: animated)
        }
    }
    
    func setMarker(at coordinate: CLLocationCoordinate2D, image: UIImage?) {
        marker?.map = nil
        marker = GMSMarker(position: coordinate)
        
        if let image = image {
            marker?.icon = resizeImage(image: image,
                                          scaledToSize: CGSize(width: 50.0,
                                                               height: 50.0))
        } else {
            marker?.icon = GMSMarker.markerImage(with: .random())
        }
        
        marker?.map = mapView
    }
    
    func showLastRoute(with bounds: GMSCoordinateBounds) {
        let insets =  UIEdgeInsets(top: Constants.navigationBarHeight + Constants.sideOffset,
                                   left: Constants.sideOffset,
                                   bottom: Constants.sideOffset,
                                   right: Constants.sideOffset
        )
        if let camera = mapView.camera(for: bounds, insets: insets) {
            mapView.animate(to: camera)
        }
    }
    
    private func resizeImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
