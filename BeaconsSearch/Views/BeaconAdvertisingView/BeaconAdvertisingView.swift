//
//  BeaconAdvertisingView.swift
//  BeaconsSearch
//
//  Created by Anton Komin on 25.04.2023.
//

import SwiftUI
import CoreBluetooth
import CoreLocation

struct BeaconAdvertisingView: View {

    @StateObject var viewModel = BeaconAdvertisingViewModel()
    @State private var isPresentingEditDialog = false
    
    var body: some View {
        VStack {
            Button(viewModel.isAdvertising ? "Stop Advertising" : "Start Advertising") {
                toggleAdvertising()
            }
            .padding()
            .foregroundColor(.white)
            .background(viewModel.isAdvertising ? Color.red : Color.green)
            .cornerRadius(10)
            
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("UUID: ").bold()
                    Text("\(viewModel.uuid)")
                        .onTapGesture {
                            copyValueToClipboard(viewModel.uuid)
                        }
                }
                HStack {
                    Text("Major: ").bold()
                    Text("\(viewModel.major)")
                        .onTapGesture {
                            copyValueToClipboard(viewModel.uuid)
                        }
                }
                HStack {
                    Text("Minor: ").bold()
                    Text("\(viewModel.minor)")
                        .onTapGesture {
                            copyValueToClipboard(viewModel.uuid)
                        }
                }
            }            
            Spacer()
        }
        .navigationBarTitle(Text("Act as a Beacon"))
        .navigationBarItems(trailing:
            Button(action: { isPresentingEditDialog = true }) {
                Image(systemName: "pencil")
            }
        )
        .onAppear {
            viewModel.beaconRegion = CLBeaconRegion(uuid: UUID(), major: 100, minor: 20, identifier: "Beep-Beep")
        }
        .sheet(isPresented: $isPresentingEditDialog) {
                BeaconRegionEditorView(isPresented: $isPresentingEditDialog,
                                                        beaconRegion: viewModel.beaconRegion,
                                                        completion:  {
                    viewModel.beaconRegion = $0
                })
        }
    }
    
    private func toggleAdvertising() {
        if viewModel.isAdvertising {
            viewModel.stopAdvertising()
        } else {
            viewModel.startAdvertising()
        }
    }
    
    private func copyValueToClipboard(_ value: String) {
        UIPasteboard.general.string = value
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

