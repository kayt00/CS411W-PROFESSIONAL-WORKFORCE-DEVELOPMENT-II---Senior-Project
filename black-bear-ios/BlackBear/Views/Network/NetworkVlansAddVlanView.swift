//
//  NetworkVlansAddVlanView.swift
//  BlackBear
//
//  Created by ktayl023 on 3/18/21.
//

import SwiftUI

struct NetworkVlansAddVlanView: View {
    @State var newVlan: VLAN = VLAN(systemName: "", roleType: "other", registeredDevices: 0, createdBy: "Admin", createdOn: "03/11/2021")
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: NetworkVlansAddVlanViewModel
    
    var body: some View {
        VStack {
            Text("Create Custom Subdivision").modifier(PrimaryLabel())
            TextField("Subdivision Name", text: $newVlan.systemName).modifier(TextFieldStyling())
            Button(action: {
                viewModel.addCustomVlan(vlan: newVlan)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create New Subdivision")
            }.modifier(UpdateButton())
        }
    }
}

struct NetworkVlansAddVlanView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkVlansAddVlanView(viewModel: NetworkVlansAddVlanViewModel(networkService: NetworkService()))
            .environmentObject(NetworkService())
    }
}
