//
//  CLBeacon + UIColor.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 10.04.2023.
//

import Foundation
import SwiftUI
import CoreLocation

extension CLBeacon {
    
    var rangeColor: Color {
        switch self.proximity {
        case .far:
            return  Color.yellow
        case .near:
            return Color.orange
        case .immediate:
            return Color.red
        default:
            return Color.gray
        }
    }
}
