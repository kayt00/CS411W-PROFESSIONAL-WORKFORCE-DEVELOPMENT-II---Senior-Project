//
//  NetworkGeneralView.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 2/7/21.
//

import SwiftUI

struct NetworkGeneralView: View {
    @State var nameInEditMode = false
    @State var pinInEditMode = false
    
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: NetworkGeneralViewModel
    
    var body: some View {
       // NavigationView {
            List {
                Section(header: HStack {
                    Text("Network Name").modifier(SectionHeader())
                    Image(systemName: "network").modifier(SFButton(color: Color.textHeaderPrimary))
                }) {
                    HStack {
                            if nameInEditMode {
                                TextField("\(networkService.getNetworkName())", text: $networkService.network.networkName).modifier(TextFieldStyling())
                            } else {
                                Text(networkService.getNetworkName()).modifier(SecondaryLabel())
                            }

                            Button(action: {
                                self.nameInEditMode.toggle()
                            }) {
                                Text(nameInEditMode ? "\(Image(systemName: "checkmark.circle.fill"))" : "\(Image(systemName: "pencil"))").modifier(SFButton(color: Color.sectionHeader))
                            }
                    }
                }.modifier(ListRowStyling())
                Section(header: HStack {
                    Text("Network PIN").modifier(SectionHeader())
                    Image(systemName: "lock.icloud").modifier(SFButton(color: Color.textHeaderPrimary))
                }) {
                    HStack {
                            if pinInEditMode {
                                TextField("\(networkService.getNetworkPIN())", text: $networkService.network.networkPIN).modifier(TextFieldStyling())
                            } else {
                                Text(networkService.getNetworkPIN()).modifier(SecondaryLabel())
                            }

                           Button(action: {
                                self.pinInEditMode.toggle()
                            }) {
                                Text(pinInEditMode ? "\(Image(systemName: "checkmark.circle.fill"))" : "\(Image(systemName: "pencil"))").modifier(SFButton(color: Color.sectionHeader))
                            }
                    }
                }.modifier(ListRowStyling())
            }.navigationBarTitle(Text("General"), displayMode: .inline)
            .listStyle(GroupedListStyle())
        //}
        .onAppear {
            self.viewModel.setup(self.networkService)
        }
    }
}

struct NetworkGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkGeneralView(viewModel: NetworkGeneralViewModel())
            .environmentObject(NetworkService())
    }
}
