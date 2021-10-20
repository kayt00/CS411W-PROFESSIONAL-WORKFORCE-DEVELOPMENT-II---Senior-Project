//
//  MFAView.swift
//  BlackBear
//
//  Created by ktayl023 on 3/9/21.
//

import SwiftUI
#warning("TO DO: MFA flow for user denying device")

struct MFAView: View {
    let requestedDevice: DEVICE
    @State private var showingDetail = false
    
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: MFAViewModel
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.presentations) private var presentations

    var body: some View {
        VStack {
            Text("\(requestedDevice.DeviceName) would like to join the network.").modifier(PrimaryLabel())
                .padding(10)
            List {
                MFADeviceDetailRow(
                    label: "Device MAC",
                    data: requestedDevice.MacAddress
                )
                MFADeviceDetailRow(
                    label: "IP Address",
                    data: requestedDevice.IPAddress
                )
                MFADeviceDetailRow(
                    label: "Manufacturer",
                    data: requestedDevice.manufacturer
                )
                MFADeviceDetailRow(
                    label: "Device OS",
                    data: requestedDevice.manufacturer
                )
                MFADeviceDetailRow(
                    label: "First Seen",
                    data: requestedDevice.CreationTimestamp
                )
                // eliminated from requirements
                /*
                MFADeviceDetailRow(
                    label: "Last Seen",
                    data: requestedDevice.LastConnected
                )
                */
            }.modifier(ListRowStyling())
            HStack {
                Button(action: {showingDetail.toggle()}) {
                    Text("Authorize")
                }.modifier(ApproveButton())
                .sheet(isPresented: $showingDetail) {
                    MFAAssignDeviceView(authorizedDevice: requestedDevice, viewModel: MFAAssignDeviceViewModel())
                        .environment(\.presentations, presentations + [$showingDetail])
                }
                Menu {
                    Button(action: {
                        viewModel.denyDeviceOnce()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Once")
                        Image(systemName: "wifi.slash")
                    })
                    Button(action: {
                        viewModel.denyDeviceForWeek()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("For a week")
                        Image(systemName: "hourglass.bottomhalf.fill")
                    })
                    Button(action: {
                        viewModel.denyDeviceIndefinitely()
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Always")
                        Image(systemName: "lock.rotation")
                    })
                } label: {
                    Text("Deny")
                    Image(systemName: "chevron.down")
                }.modifier(DenyButton())

            }.padding(.bottom, 50)
        }
        .onAppear {
            self.viewModel.setup(self.networkService)
        }
    }
}

struct MFAView_Previews: PreviewProvider {

    static var previews: some View {
        MFAView(requestedDevice: DEVICE(), viewModel: MFAViewModel())
            .environmentObject(NetworkService())
    }
}

struct MFADeviceDetailRow: View {
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
