//
//  SshEditPwdView.swift
//  BlackBear
//
//  Created by ktayl023 on 2/9/21.
//

import SwiftUI

struct SSHServerEditPasswordView: View {
    @State var currentPassword = ""
    @State var newPassword = ""
    @State var newPasswordReentry = ""
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: SSHServerEditPasswordViewModel
    
    var body: some View {
        List {
            VStack {
                CurrentSSHPassword(currentPassword: $currentPassword)
                NewSSHPassword(newPassword: $newPassword, newPasswordReentry: $newPasswordReentry)
                Button(action: {viewModel.updateSSHPassword(currentPassword: currentPassword, newPassword: newPassword, newPasswordReentry: newPasswordReentry)}) {
                    Text("Update Password")
                }.modifier(UpdateButton())
            }.modifier(ListRowStyling())
            .padding()
        }
        .navigationBarTitle(Text("Update SSH Password"), displayMode: .inline)
        .listStyle(GroupedListStyle())
        .onAppear {
            self.viewModel.setup(self.networkService)
        }
    }
}

struct SSHServerEditPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SSHServerEditPasswordView(viewModel: SSHServerEditPasswordViewModel())
            .environmentObject(NetworkService())
    }
}

struct CurrentSSHPassword: View {
    @Binding var currentPassword: String
    
    var body: some View {
        Text("Current password").modifier(SecondaryLabel())
        SecureField("", text: $currentPassword).modifier(SecureFieldStyling())
    }
}

struct NewSSHPassword: View {
    @Binding var newPassword: String
    @Binding var newPasswordReentry: String
    
    var body: some View {
        Text("New Password").modifier(SecondaryLabel())
        SecureField("", text: $newPassword).modifier(SecureFieldStyling())
            
        Text("Re-Enter New Password").modifier(SecondaryLabel())
        SecureField("", text: $newPasswordReentry).modifier(SecureFieldStyling())
    }
}

