//
//  NetworkUsersView.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 2/7/21.
//

import SwiftUI

struct NetworkUsersView: View {
    
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: NetworkUsersViewModel
    
    var body: some View {
         List {
            Section(header: HStack {
                Text("Administrative").modifier(SectionHeader())
                Image(systemName: "wand.and.stars.inverse").modifier(SFButton(color: Color.textHeaderPrimary))
            }) {
                ForEach(networkService.devices) { device in
                  /*
                    if device.role == .admin {
                        DeviceRow(device: device)
                    }
                  */
 
                }
            }
            Section(header: Text("Standard").modifier(SectionHeader())) {
                ForEach(networkService.devices) { device in
                   /*
                    if device.role == .standard {
                        DeviceRow(device: device)
                    }
                    */
                }
            }
         }
        .navigationBarTitle(Text("Users"), displayMode: .inline)
         .navigationBarItems(trailing: Button(action: {viewModel.inviteNewUser()}) {Image(systemName: "person.badge.plus").modifier(SFButton(color: .success))})
         .listStyle(GroupedListStyle())
         .onAppear {
             self.viewModel.setup(self.networkService)
         }
    }
}

struct NetworkUserView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkUsersView(viewModel: NetworkUsersViewModel())
            .environmentObject(NetworkService())
    }
}
