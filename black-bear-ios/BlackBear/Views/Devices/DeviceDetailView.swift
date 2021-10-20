//
//  DeviceDetailView.swift
//  BlackBear
//
//  Created by ktayl023 on 2/11/21.
//

import SwiftUI

struct DeviceDetailView: View {
    
    var selectedDevice: DEVICE
    @State var deviceSelectedToBeRemoved = false
   
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: DeviceDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        VStack {
            List {
                Section {
                    DeviceDetailRow(
                        label: "MAC",
                        data: selectedDevice.MacAddress
                    )
                    DeviceDetailRow(
                        label: "IP Address",
                        data: selectedDevice.IPAddress
                    )
                    DeviceDetailRow(
                        label: "Status",
                        data: selectedDevice.status.rawValue
                    )
                    if selectedDevice.VlanId == .guest {
                        let vlanName = "Guest"
                        DeviceDetailRow(
                            label: "VLAN",
                            data: vlanName
                        )
                    } else if selectedDevice.VlanId == .smartHome {
                        let vlanName = "Smart Home"
                        DeviceDetailRow(
                            label: "VLAN",
                            data: vlanName
                        )
                    } else if selectedDevice.VlanId == .computerAndPhone {
                        let vlanName = "Computers / Phones"
                        DeviceDetailRow(
                            label: "VLAN",
                            data: vlanName
                        )
                    } else if selectedDevice.VlanId == .gamingAndTv {
                        let vlanName = "Gaming / TV"
                        DeviceDetailRow(
                            label: "VLAN",
                            data: vlanName
                        )
                    } else {
                        DeviceDetailRow(
                            label: "VLAN",
                            data: "VLAN \(selectedDevice.VlanId.rawValue)"
                        )
                    }
                    DeviceDetailRow(
                        label: "Connected Since",
                        data: selectedDevice.ConnectedSince
                    )
                    if let creator = selectedDevice.Creator {
                        DeviceDetailRow(
                            label: "Registered By",
                            data: "\(creator)"
                        )
                    }
                    DeviceDetailRow(
                        label: "Average Daily Upload Traffic",
                        data: "\(selectedDevice.UploadLimitMB)"
                    )
                    DeviceDetailRow(
                        label: "Average Daily Download Traffic",
                        data: "\(selectedDevice.DownloadLimitMB)"
                    )
                }.modifier(ListRowStyling())
            }
            Spacer()
            Button(action: {deviceSelectedToBeRemoved = true}) {
                Text("Suspend Device")
            }.alert(isPresented: $deviceSelectedToBeRemoved) {
                deviceRemovalConfirmation(deviceSelection: selectedDevice)
            }
            .modifier(RemoveButton())
            .padding(.bottom, 20)
            .navigationBarTitle(Text(selectedDevice.DeviceName), displayMode: .inline)
        }
        .onAppear {
            self.viewModel.setup(self.networkService)
        }
    }
}
/*
struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(selectedDevice: DEVICE(from: JSONDecoder()), viewModel: DeviceDetailViewModel())
            .environmentObject(NetworkService())
    }
}
 */

struct DeviceDetailRow: View {
    let label: String
    let data: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label).modifier(SecondaryLabel())
            Text(data).modifier(LabelContents())
        }
        .font(.body)
    }
}

extension DeviceDetailView {
    private func deviceRemovalConfirmation(deviceSelection: DEVICE) -> Alert {
        return Alert(
            title: Text("Are you sure you want to suspend \(deviceSelection.DeviceName)?"),
            message: Text("\(deviceSelection.DeviceName) will automatically be disconnected and unauthorized from the home network."),
            primaryButton: .default(Text("Suspend")) {
                viewModel.removeDevice(device: selectedDevice)
                presentationMode.wrappedValue.dismiss()
            },
            secondaryButton: .cancel()
        )
    }
}
