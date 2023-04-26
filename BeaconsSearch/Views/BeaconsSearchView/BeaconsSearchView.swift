//
//  BeaconsSearchView.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 10.04.2023.
//

import SwiftUI
import CoreLocation
struct BeaconsSearchView: View {
    
    @StateObject var viewModel = BeaconsSearchViewModel([CLBeaconRegion(uuid: UUID(uuidString: "A2FA7357-C8CD-4B95-98FD-9D091CE43337")!, major: 10, identifier: "")])
    @State private var isPresentingEditDialog = false
    
    var body: some View {
        VStack {
            viewModel.closestBeacon?.rangeColor ?? Color.white
            Text(viewModel.closestBeacon?.proximity.howFar ?? "NO BEACONS NEAR")
                .font(.title)
            if let closestBeacon = viewModel.closestBeacon {
                VStack(alignment: .leading) {
                    HStack {
                        Text("UUID: ").bold()
                        Text("\(closestBeacon.uuid)")
                    }
                    HStack {
                        Text("Major: ").bold()
                        Text("\(closestBeacon.major)")
                    }
                    HStack {
                        Text("Minor: ").bold()
                        Text("\(closestBeacon.minor)")
                    }
                }
            }
        }
        .navigationBarItems(trailing:
            Button(action: { isPresentingEditDialog = true }) {
                Image(systemName: "pencil")
            }
        )
        .sheet(isPresented: $isPresentingEditDialog) {
                BeaconRegionEditorView(isPresented: $isPresentingEditDialog,
                                                        beaconRegion: viewModel.beaconRegions.first,
                                                        completion:  {
                    viewModel.updateRegionsWith([$0])
                })
        }
    }
}

struct BeaconsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconsSearchView()
    }
}
