//
//  CGFloat+Extension.swift
//  MapsLocation
//
//  Created by Alexey on 18.08.2021.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
