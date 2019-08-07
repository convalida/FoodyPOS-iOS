//
//  Double.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 13/09/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
extension Double {
    /// Round off a double data
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
