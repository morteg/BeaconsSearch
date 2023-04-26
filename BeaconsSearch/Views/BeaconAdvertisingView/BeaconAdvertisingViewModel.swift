//
//  BeaconAdvertisingViewModel.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 25.04.2023.
//

import Foundation
import CoreBluetooth
import CoreLocation

class BeaconAdvertisingViewModel {

    private var beaconsTransmitter: BeaconTransmitter?
    
    @Published var beaconRegion: CLBeaconRegion? {
        didSet {
            updateBeaconRegion()
        }
    }
    
    @Published private(set) var isAdvertising = false
    
    @Published private(set) var uuid: String = ""
    @Published private(set) var major: String = ""
    @Published private(set) var minor: String = ""
    
    
    func startAdvertising() {
        guard let beaconsTransmitter = self.beaconsTransmitter else { return }
        beaconsTransmitter.startAdvertising()
        isAdvertising = true
    }
    
    func stopAdvertising() {
        beaconsTransmitter?.stopAdvertising()
        isAdvertising = false
    }
    
    private func updateBeaconRegion() {
        if isAdvertising {
            stopAdvertising()
        }
        guard let beaconRegion = self.beaconRegion else { return }
        uuid = beaconRegion.uuid.uuidString
        major = beaconRegion.major?.stringValue ?? ""
        minor = beaconRegion.minor?.stringValue ?? ""
        beaconsTransmitter = BeaconTransmitter(beaconRegion)
    }

}

extension BeaconAdvertisingViewModel: ObservableObject { }

//extension BeaconsSearchViewModel: BeaconsProviderDelegate {
//
//    func didRange(_ beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
//        guard !beacons.isEmpty else { return }
//        self.closestBeacon = beacons.filter { $0.accuracy > 0 }.first
//    }
//}
