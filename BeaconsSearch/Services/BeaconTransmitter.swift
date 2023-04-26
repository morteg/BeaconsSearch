//
//  BeaconTransmitter.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 24.04.2023.
//

import CoreBluetooth
import CoreLocation

class BeaconTransmitter: NSObject {
    
    private var peripheralManager: CBPeripheralManager?
    let region: CLBeaconRegion
    
    init(_ region: CLBeaconRegion) {
        self.region = region
    }
    
    init(_ uuid: UUID, major: CLBeaconMajorValue, minor:CLBeaconMinorValue, identifier: String) {
        region = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: identifier)
    }
    
    func startAdvertising() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func stopAdvertising() {
        peripheralManager?.stopAdvertising()
        peripheralManager = nil
    }

}

// MARK: CBPeripheralManagerDelegate
extension BeaconTransmitter: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            let data = region.peripheralData(withMeasuredPower: nil) as? [String: Any]
            peripheral.startAdvertising(data)
        } else {
            peripheral.stopAdvertising()
            stopAdvertising()
        }
    }
}

