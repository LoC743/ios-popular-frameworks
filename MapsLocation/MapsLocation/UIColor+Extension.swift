//
//  UIColor+Extension.swift
//  MapsLocation
//
//  Created by Alexey on 18.08.2021.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
