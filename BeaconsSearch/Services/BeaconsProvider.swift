//
//  BeaconsProvider.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 10.04.2023.
//

import Foundation
import CoreLocation

protocol BeaconsProviderDelegate: AnyObject {
    func didRange(_ beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint)
}

class BeaconsProvider: NSObject {
    weak var delegate: BeaconsProviderDelegate?
    
    init(locationManager: CLLocationManager = CLLocationManager(), beaconRegions: [CLBeaconRegion]) {
        self.locationManager = locationManager
        self.beaconRegions = beaconRegions
        locationManager.requestAlwaysAuthorization()
        super.init()
        locationManager.delegate = self
    }

    var locationManager: CLLocationManager
    private(set) var beaconRegions:  [CLBeaconRegion]
    
    func requestPermissions() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func startScanning() {
        beaconRegions.forEach {
            locationManager.startMonitoring(for: $0)
        }
    }
    
    func stopScanning() {
        beaconRegions.forEach {
            locationManager.stopMonitoring(for: $0)
        }
    }
    
    func updateRegionsWith(_ newRegions: [CLBeaconRegion]) {
        stopScanning()
        self.beaconRegions = newRegions
        startScanning()
    }
    
}

// MARK: CLLocationManagerDelegate
extension BeaconsProvider: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didDetermineState state: CLRegionState, for region: CLRegion) {
        guard let beaconRegion = region as? CLBeaconRegion else { return }
        if state == .inside {
            // Start ranging when inside a region.
            manager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        } else {
            // Stop ranging when not inside a region.
            manager.stopRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didRange beacons: [CLBeacon],
                         satisfying beaconConstraint: CLBeaconIdentityConstraint) {
       guard let closestBeacon = beacons.first else { return }
       delegate?.didRange([closestBeacon], satisfying: beaconConstraint)
    }
}

