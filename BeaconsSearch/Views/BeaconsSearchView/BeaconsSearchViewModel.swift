//
//  BeaconsSearchViewModel.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 10.04.2023.
//

import Foundation
import CoreLocation

class BeaconsSearchViewModel {

    private let beaconsProvider: BeaconsProvider
    private(set) var beaconRegions: [CLBeaconRegion]
    
    @Published private(set) var closestBeacon: CLBeacon?
    
    init(_ beaconRegions: [CLBeaconRegion]) {
        self.beaconRegions = beaconRegions
        self.beaconsProvider = BeaconsProvider(beaconRegions: beaconRegions)
        self.beaconsProvider.delegate = self
    }
    
    func updateRegionsWith(_ newRegions: [CLBeaconRegion]) {
        self.beaconRegions = newRegions
        self.beaconsProvider.updateRegionsWith(newRegions)
    }
    
    func stopSearching() {
        beaconsProvider.stopScanning()
    }
}

extension BeaconsSearchViewModel: ObservableObject { }

extension BeaconsSearchViewModel: BeaconsProviderDelegate {
    
    func didRange(_ beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        guard !beacons.isEmpty else { return }
        self.closestBeacon = beacons.filter { $0.accuracy > 0 }.first
    }
}


