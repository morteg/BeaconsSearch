//
//  ContentView.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 10.04.2023.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BeaconsSearchView()) {
                    Text("Search for Beacons")
                }
                NavigationLink(destination: BeaconAdvertisingView()) {
                    Text("Act as a Beacon")
                }
            }
            .navigationBarTitle(Text("iBeacon Demo"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
