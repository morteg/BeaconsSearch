//
//  BeaconRegionEditorView.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 25.04.2023.
//

import SwiftUI
import CoreLocation

struct BeaconRegionEditorView: View {
    @Binding var isPresented: Bool
    @State private var uuidString = UUID().uuidString
    @State private var major = ""
    @State private var minor = ""
    @State private var identifier = ""
    
    var beaconRegion: CLBeaconRegion?
    var completion: ((CLBeaconRegion) -> Void)?
    
    init(isPresented: Binding<Bool>, beaconRegion: CLBeaconRegion? = nil, completion: ((CLBeaconRegion) -> Void)? = nil) {
        _isPresented = isPresented
        self.beaconRegion = beaconRegion
        self.completion = completion
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("iBeacon UUID")) {
                    TextField("UUID", text: $uuidString)
                }
                Section(header: Text("iBeacon Major and Minor")) {
                    TextField("Major", text: $major)
                        .keyboardType(.numberPad)
                    TextField("Minor", text: $minor)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("iBeacon Identifier")) {
                    TextField("Identifier", text: $identifier)
                }
            }
            .navigationBarTitle("iBeacon Values")
            .navigationBarItems(trailing: Button("Save") {
                let beaconRegion: CLBeaconRegion!
                let uuid = UUID(uuidString: uuidString) ?? UUID()
                if let major = UInt16(self.major), let minor = UInt16(self.minor) {
                    beaconRegion = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: identifier)
                } else if let major = UInt16(self.major) {
                    beaconRegion = CLBeaconRegion(uuid: uuid, major: major, identifier: identifier)
                } else {
                    beaconRegion = CLBeaconRegion(uuid: uuid, identifier: identifier)
                }
                isPresented = false
                completion?(beaconRegion)
            })
        }
        .onAppear() {
            if let uuidString = beaconRegion?.uuid.uuidString {
                self.uuidString = uuidString
            }
            self.major = beaconRegion?.major.flatMap { "\($0)" } ?? ""
            self.minor = beaconRegion?.minor.flatMap { "\($0)" } ?? ""
            self.identifier = beaconRegion?.identifier ?? ""
        }
    }
}

