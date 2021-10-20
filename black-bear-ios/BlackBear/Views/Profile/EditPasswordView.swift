//
//  EditPwdView.swift
//  BlackBear
//
//  Created by ktayl023 on 2/9/21.
//

import SwiftUI

struct EditPasswordView: View {
    @State var currentPassword = ""
    @State var newPassword = ""
    @State var newPasswordReentry = ""
    
    @EnvironmentObject var userService: UserService
    @ObservedObject var viewModel: EditPasswordViewModel
    
    var body: some View {

        List {
            VStack {
                CurrentProfilePassword(currentPassword: $currentPassword)
                NewProfilePassword(newPassword: $newPassword, newPasswordReentry: $newPasswordReentry)
                Button(action: {viewModel.updatePassword(currentPassword: currentPassword, newPassword: newPassword, newPasswordReentry: newPasswordReentry)} ) {
                    Text("Update Password")
                }.modifier(UpdateButton())
            }.modifier(ListRowStyling())
            .padding()
        }
        .navigationBarTitle(Text("Update Profile Password"), displayMode: .inline)
        .listStyle(GroupedListStyle())
        .font(Font.custom("Avenir", size: 12))
    }
}

struct CurrentProfilePassword: View {
    @Binding var currentPassword: String
    
    var body: some View {
        Text("Current password").modifier(SecondaryLabel())
        SecureField("", text: $currentPassword).modifier(SecureFieldStyling())
    }
}

struct NewProfilePassword: View {
    @Binding var newPassword: String
    @Binding var newPasswordReentry: String
    
    var body: some View {
        Text("New Password").modifier(SecondaryLabel())
        SecureField("", text: $newPassword).modifier(SecureFieldStyling())
        
        Text("Re-Enter New Password").modifier(SecondaryLabel())
        SecureField("", text: $newPasswordReentry).modifier(SecureFieldStyling())
    }
}

struct EditPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        EditPasswordView(viewModel: EditPasswordViewModel())
            .environmentObject(UserService())
    }
}
