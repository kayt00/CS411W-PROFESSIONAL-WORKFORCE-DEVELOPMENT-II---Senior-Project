//
//  SSHServerView.swift
//  BlackBear
//
//  Created by Katie Taylor on 2/7/21.
//

import SwiftUI

struct SSHServerView: View {
    @State var nameInEditMode = false
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: SSHServerViewModel
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("IP").modifier(SectionHeader())
                Image(systemName: "globe").modifier(SFButton(color: .textHeaderPrimary))
            }) {
                Text(networkService.ssh.ip).modifier(SecondaryLabel())
            }.modifier(ListRowStyling())
            Section(header: HStack {
                Text("Username").modifier(SectionHeader())
                Image(systemName: "person").modifier(SFButton(color: .textHeaderPrimary))
            }) {
                
                HStack {
                        if nameInEditMode {
                            TextField("\(networkService.ssh.username)", text: $networkService.ssh.username).modifier(TextFieldStyling())
                        } else {
                            Text("\(networkService.ssh.username)").modifier(SecondaryLabel())
                        }

                        Button(action: {
                            self.nameInEditMode.toggle()
                        }) {
                            Text(nameInEditMode ? "\(Image(systemName: "checkmark.circle.fill"))" : "\(Image(systemName: "pencil"))").modifier(SFButton(color: Color.sectionHeader))
                        }
                }
                
                NavigationLink(destination: SSHServerEditPasswordView(viewModel: SSHServerEditPasswordViewModel())) {
                    Text("Update SSH Password").modifier(SecondaryLabel())
                }
            }.modifier(ListRowStyling())
        }
        .navigationBarTitle(Text("SSH Server"), displayMode: .inline)
       /* .navigationBarItems(trailing: Button(action: {viewModel.addSSH()}) {
            Image(systemName: "plus").modifier(SFButton(color: .success))
        }) */
        .listStyle(GroupedListStyle())
        .onAppear {
            self.viewModel.setup(self.networkService)
        }
    }
}

struct SSHServerView_Previews: PreviewProvider {
    static var previews: some View {
        SSHServerView(viewModel: SSHServerViewModel())
            .environmentObject(NetworkService())
    }
}
