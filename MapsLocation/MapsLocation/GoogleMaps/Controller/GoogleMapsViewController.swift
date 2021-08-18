//
//  GoogleMapsViewController.swift
//  MapsLocation
//
//  Created by Alexey on 18.08.2021.
//

import UIKit

class GoogleMapsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var googleMapsView: GoogleMapsView {
        return self.view as! GoogleMapsView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = GoogleMapsView()
    }
}
