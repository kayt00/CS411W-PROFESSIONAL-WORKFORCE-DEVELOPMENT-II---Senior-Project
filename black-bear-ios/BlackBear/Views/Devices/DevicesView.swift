//
//  DevicesView.swift
//  Black Bear
//
//  Created by Jeremy Fleshman on 2/6/21.
//

import SwiftUI
import Combine

enum ActiveAlertDevices {
    case deviceAdded, deviceRejected, deviceSuspended
}

struct DevicesView: View {
    @EnvironmentObject var networkService: NetworkService
    @EnvironmentObject var userService: UserService
    @ObservedObject var viewModel: DevicesViewModel
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlertDevices = .deviceAdded

    #warning("TODO: Remove this and pass in device from payload")
    var requestedDevice = DEVICE()
    @Environment(\.presentations) private var presentations
    @State private var showingDetail = false
    @Environment(\.deeplink) var deeplink
    
    /* code source: https://www.hackingwithswift.com/books/ios-swiftui/triggering-events-repeatedly-using-a-timer

    It asks the timer to fire every 5 seconds.
    It says the timer should run on the main thread.
    It says the timer should run on the common run loop, which is the one you’ll want to use most of the time. (Run loops lets iOS handle running code while the user is actively doing something, such as scrolling in a list.)
    It connects the timer immediately, which means it will start counting time.
    It assigns the whole thing to the timer constant so that it stays alive.
    Tolerance - allows iOS to perform important energy optimization, because it can fire the timer at any point between its scheduled fire time and its scheduled fire time plus the tolerance you specify
    */
    let timer = Timer.publish(every: 3, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
           ZStack {
                List {

                    if viewModel.pendingDevices.count > 0 {
                        Section(header: HStack {
                            Image(systemName: "wifi.exclamationmark").modifier(SFButton(color: Color.textHeaderPrimary))
                            Text("Pending Approval").modifier(PendingApprovalSectionHeader())
                        }) {
                            ForEach(viewModel.pendingDevices) { DEVICE in
                                if DEVICE.status == .pendingApproval {
                                    MFADeviceRow(requestedDevice: DEVICE)
                                }
                            }
                        }
                    }

                    Section(header: HStack {
                        Image(systemName: "person.3").modifier(SFButton(color: Color.textHeaderPrimary))
                        Text("Guest").modifier(SectionHeader())
                    }) {
                        ForEach(viewModel.devices) { DEVICE in
                            if DEVICE.status == .connected {
                                if DEVICE.VlanId == .guest {
                                    DeviceRow(device: DEVICE)
                                }
                            }
                        }
                    }
                    
                    Section(header: HStack {
                        Image(systemName: "homekit").modifier(SFButton(color: Color.textHeaderPrimary))
                        Text("Smart Home").modifier(SectionHeader())
                    }) {
                        ForEach(viewModel.devices) { DEVICE in
                            if DEVICE.status == .connected {
                                if DEVICE.VlanId == .smartHome {
                                    DeviceRow(device: DEVICE)
                                }
                            }
                        }
                    }
                    
                    Section(header: HStack {
                        Image(systemName: "laptopcomputer.and.iphone").modifier(SFButton(color: Color.textHeaderPrimary))
                        Text("Computers / Phones").modifier(SectionHeader())
                    }) {
                        ForEach(viewModel.devices) { DEVICE in
                            if DEVICE.status == .connected {
                                if DEVICE.VlanId == .computerAndPhone {
                                    DeviceRow(device: DEVICE)
                                }
                            }
                        }
                    }
                    
                    Section(header: HStack {
                        Image(systemName: "gamecontroller").modifier(SFButton(color: Color.textHeaderPrimary))
                        Text("Gaming / TV").modifier(SectionHeader())
                    }) {
                        ForEach(viewModel.devices) { DEVICE in
                            if DEVICE.status == .connected {
                                if DEVICE.VlanId == .gamingAndTv {
                                    DeviceRow(device: DEVICE)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Other").modifier(SectionHeader())) {
                        ForEach(viewModel.devices) { DEVICE in
                            if DEVICE.status == .connected {
                                if DEVICE.VlanId.rawValue > 4 {
                                    DeviceRow(device: DEVICE)
                                }
                            }
                        }
                    }
/*
                    Section(header: Text("Gaming / TV").modifier(SectionHeader())) {
                        ForEach(networkService.devices) { device in
                            if device.vlan == .gamingAndTv {
                                DeviceRow(device: device)
                            }
                        }
                    }

                    Section(header: Text("Guests").modifier(SectionHeader())) {
                        ForEach(networkService.devices) { device in
                            if device.vlan == .guest {
                                DeviceRow(device: device)
                            }
                        }
                    }
 */
                }
                .listStyle(SidebarListStyle())
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                        case .deviceAdded:
                            return Alert(title: Text("Device added successfully!"))
                        case .deviceRejected:
                            return Alert(title: Text("Device connection was rejected!"))
                        case .deviceSuspended:
                            return Alert(title: Text("Device connection was suspended!"))
                    }
                }

            }
           .navigationBarTitle(Text("Devices"), displayMode: .inline)
            .navigationBarItems(leading: leadingNavItems(), trailing: trailingNavItems())
        }.onAppear {
            self.viewModel.setup(self.userService, self.networkService)
            self.viewModel.allDevices()
            self.viewModel.fetchPendingDevices()
           // self.viewModel.fetchRandomDevices()
        }.onReceive(timer) { time in
            viewModel.fetchPendingDevices()
            // To keep the portal and iOS app in sync for the demo
            // I'm moving the allDevices call into the timer as well
            viewModel.allDevices()
        }.onReceive(networkService.$deviceAdded) {
            activeAlert = .deviceAdded
            showDelayedAlert(with: $0)
        }.onReceive(networkService.$deviceRejected) {
            activeAlert = .deviceRejected
            showDelayedAlert(with: $0)
        }.onReceive(networkService.$deviceSuspended) {
            activeAlert = .deviceSuspended
            showDelayedAlert(with: $0)
        }.onChange(of: deeplink) { deeplink in
            guard deeplink == .addDevice else { return }
            showingDetail = true
        }
    }

    func showDelayedAlert(with value: Bool) {
        #warning("TODO: Replace this with logic to detect no views are presented")
        DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
            showAlert = value
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView(viewModel: DevicesViewModel(), requestedDevice: DEVICE())
            .environmentObject(NetworkService())
    }
}

 struct DeviceRow: View {
     var device: DEVICE

     var body: some View {
        NavigationLink(destination: DeviceDetailView(selectedDevice: device, viewModel: DeviceDetailViewModel())) {
             VStack(alignment: .leading) {
                Text(device.DeviceName).modifier(SecondaryLabel())
             }.modifier(LabelContents())
         }.modifier(NavigationTab())
     }
 }

struct MFADeviceRow: View {
    @State private var showingDetail = false
    @Environment(\.presentations) private var presentations
    var requestedDevice: DEVICE

    var body: some View {
        VStack(alignment: .leading) {
            Button(requestedDevice.DeviceName) { showingDetail.toggle() }
                .sheet(isPresented: $showingDetail) {
                    MFAView(requestedDevice: requestedDevice, viewModel: MFAViewModel())
                        .environment(\.presentations, presentations + [$showingDetail])
                }.modifier(SecondaryLabel())
        }.modifier(LabelContents())
    }
}

struct trailingNavItems: View {
    @State private var showingDetail = false
    @Environment(\.presentations) private var presentations
    var requestedDevice = DEVICE()
    
    var body: some View {
        HStack {
//            Button("\(Image(systemName: "icloud.and.arrow.up"))") {
//                        showingDetail.toggle()
//                    }
//                    .sheet(isPresented: $showingDetail) {
//                        MFAView(requestedDevice: requestedDevice, viewModel: MFAViewModel())
//                            .environment(\.presentations, presentations + [$showingDetail])
//                    }
            NavigationLink(destination: OfflineDevicesView(viewModel: OfflineDevicesViewModel(), devicesViewModel: DevicesViewModel())) {
                Image(systemName: "wifi.slash").modifier(SFButton(color: Color.warning))
            }
        }
    }
}

//TO DO: Invalid action for filter & search buttons
struct leadingNavItems: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "line.horizontal.3.decrease.circle").modifier(SFButton(color: Color.sectionHeader))
            }
            Button(action: {}) {
                Image(systemName: "magnifyingglass").modifier(SFButton(color: Color.sectionHeader))
            }
        }
    }
}
