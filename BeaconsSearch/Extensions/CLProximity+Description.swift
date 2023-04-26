//
//  CLProximity+Description.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 10.04.2023.
//

import Foundation
import CoreLocation

extension CLProximity {
    
    var howFar: String {
        switch self {
        case .far:
            return  "FAR"
        case .near:
            return "NEAR"
        case .immediate:
            return "HERE!"
        default:
            return "UNKNOWN"
        }
    }
}
