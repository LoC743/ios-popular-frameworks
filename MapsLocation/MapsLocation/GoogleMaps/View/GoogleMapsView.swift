//
//  GoogleMapsView.swift
//  MapsLocation
//
//  Created by Alexey on 18.08.2021.
//

import UIKit

final class GoogleMapsView: UIView {
    // MARK: - Subviews
    
    
    
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
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .gray
    }
}
