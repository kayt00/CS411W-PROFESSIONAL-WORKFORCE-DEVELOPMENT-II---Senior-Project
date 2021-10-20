//
//  MFAAssignDeviceView.swift
//  BlackBear
//
//  Created by ktayl023 on 3/9/21.
//

import SwiftUI

#warning("TO DO: alert message confirming user wants to assign device to selected VLAN before adding device to VLAN -> then dismiss sheet/modal -> redirect to dashboard")

struct MFAAssignDeviceView: View {
    @State var authorizedDevice: DEVICE
    @EnvironmentObject var networkService: NetworkService
    @EnvironmentObject var userService: UserService
    @ObservedObject var viewModel: MFAAssignDeviceViewModel
    @Environment(\.presentations) private var presentations
    
    //@Environment(\.presentationMode) var presentationMode
    #warning("TODO: Refactor the alert flags to be handled more compactly through a state manager")
    // https://danielsaidi.com/blog/2020/06/07/swiftui-alerts Example solution
    @State var pcPhoneChosen = false
    @State var gameTvChosen = false
    @State var smartHomeChosen = false
    @State var guestChosen = false
    
    var body: some View {
        VStack {
            Text("Where should \(authorizedDevice.DeviceName) be assigned?").modifier(PrimaryLabel())
                .padding(.top, 100)
            Spacer()
            HStack {
               VStack {
                    Text("PC / Phones").modifier(MFALabels())
                    Button(action: {
                        pcPhoneChosen = true
                        authorizedDevice.VlanId = .computerAndPhone
                    }) {
                        Image(systemName: "desktopcomputer").modifier(SFButton(color: Color.black))
                        Image("iphone")
                    }.alert(isPresented: $pcPhoneChosen) {
                        vlanConfirmation(device: authorizedDevice, vlanSelection: .computerAndPhone)
                    }.modifier(MFAButtons())
               }
               VStack {
                    Text("Gaming / TV").modifier(MFALabels())
                    Button(action: {
                        gameTvChosen = true
                        authorizedDevice.VlanId = .gamingAndTv
                    }) {
                        VStack {
                            Image(systemName: "gamecontroller.fill").modifier(SFButton(color: Color.black))
                            Image(systemName: "film").modifier(SFButton(color: Color.black))
                        }
                        VStack {
                            Image(systemName: "tv.music.note").modifier(SFButton(color: Color.black))
                            Image(systemName: "play.rectangle.fill").modifier(SFButton(color: Color.black))
                        }
                    }.alert(isPresented: $gameTvChosen) {
                        vlanConfirmation(device: authorizedDevice, vlanSelection: .gamingAndTv)
                    }.modifier(MFAButtons())
               }.padding()

                
                VStack {
                    Text("Smart Home").modifier(MFALabels())
                    Button(action: {
                        smartHomeChosen = true
                        authorizedDevice.VlanId = .smartHome
                    }) {
                        VStack {
                            Image(systemName: "lightbulb").modifier(SFButton(color: Color.black))
                            Image(systemName: "printer.fill").modifier(SFButton(color: Color.black))
                        }
                        VStack {
                            Image(systemName: "video.fill").modifier(SFButton(color: Color.black))
                            Image(systemName: "thermometer").modifier(SFButton(color: Color.black))
                        }
                    }.alert(isPresented: $smartHomeChosen) {
                        vlanConfirmation(device: authorizedDevice, vlanSelection: .smartHome)
                    }.modifier(MFAButtons())
                }
            }
            
            VStack {
                    Text("Guest").modifier(MFAGuestLabel())
                    Button(action: {
                        guestChosen = true
                        authorizedDevice.VlanId = .guest
                    }) {
                        Image("guest")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30)
                    }.alert(isPresented: $guestChosen) {
                        vlanGuestConfirmation(device: authorizedDevice, vlanSelection: .guest)
                    }.modifier(MFAGuestButton())
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            self.viewModel.setup(self.networkService, self.userService)
        }
    }
}

struct MFAAssignDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        MFAAssignDeviceView(authorizedDevice: DEVICE(), viewModel: MFAAssignDeviceViewModel())
            .environmentObject(NetworkService())
    }
}

extension MFAAssignDeviceView {
    private func vlanConfirmation(device: DEVICE, vlanSelection: Vlan) -> Alert {
        return Alert(
            title: Text("Are you sure you want to add \(device.DeviceName) to the \(vlanSelection.rawValue) subdivision?"),
                message: Text("Only add to the \(vlanSelection.rawValue) subdivision if the device will be on your network often. Use the Guest subdivision for any devices that aren't yours."),
            primaryButton: .default(Text("Add Device")) {
                viewModel.addDevice(device)
                dismissSheets()
            },
            secondaryButton: .cancel()
        )
    }
    
    private func vlanGuestConfirmation(device: DEVICE, vlanSelection: Vlan) -> Alert {
        return Alert(
            title: Text("Are you sure you want to add \(device.DeviceName) to the \(vlanSelection.rawValue) subdivision?"),
                message: Text("Use the Guest subdivision for any devices that aren't yours."),
            primaryButton: .default(Text("Add Device")) {
                viewModel.addDevice(device)
                dismissSheets()
            },
            secondaryButton: .cancel()
        )
    }

    private func dismissSheets() {
        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
