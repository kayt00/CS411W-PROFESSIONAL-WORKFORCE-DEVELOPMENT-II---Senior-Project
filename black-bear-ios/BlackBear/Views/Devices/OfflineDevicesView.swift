//
//  OfflineDevicesView.swift
//  BlackBear
//
//  Created by ktayl023 on 2/11/21.
//

import SwiftUI

struct OfflineDevicesView: View {
    @EnvironmentObject var networkService: NetworkService
    @EnvironmentObject var userService: UserService
    @ObservedObject var viewModel: OfflineDevicesViewModel
    @ObservedObject var devicesViewModel: DevicesViewModel
    
    var body: some View {
            ZStack {
                List {
                    Section() {
                            ForEach(devicesViewModel.devices) { DEVICE in
                                if DEVICE.status == .disconnected {
                                    DeviceRow(device: DEVICE)
                                }
                            }
                            ForEach(devicesViewModel.randomDevices) { DEVICE in
                                if DEVICE.status == .disconnected {
                                    DeviceRow(device: DEVICE)
                                }
                            }
                    }
                    /*
                    Section(header: Text("Smart Home").modifier(SectionHeader())) {
                        ForEach(networkService.offlineDevices) { device in
                            if device.vlan == .smartHome {
                                DeviceRow(device: device)
                            }
                        }
                    }

                    Section(header: Text("Gaming / TV").modifier(SectionHeader())) {
                        ForEach(networkService.offlineDevices) { device in
                            if device.vlan == .gamingAndTv {
                                DeviceRow(device: device)
                            }
                        }
                    }

                    Section(header: Text("Guests").modifier(SectionHeader())) {
                        ForEach(networkService.offlineDevices) { device in
                            if device.vlan == .guest {
                                DeviceRow(device: device)
                            }
                        }
                    }
                     */
                }
                .listStyle(GroupedListStyle())
            }.navigationBarTitle(Text("Offline Devices"), displayMode: .inline)
            .onAppear {
                self.viewModel.setup(self.networkService)
                self.devicesViewModel.setup(self.userService, self.networkService)
            }
    }
}

struct OfflineDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineDevicesView(viewModel: OfflineDevicesViewModel(), devicesViewModel: DevicesViewModel())
            .environmentObject(NetworkService())
    }
}
