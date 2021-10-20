//
//  EditProfileView.swift
//  BlackBear
//
//  Created by ktayl023 on 2/9/21.
//

import SwiftUI

struct EditProfileView: View {
    @State var nameInEditModeName = false
    @State var nameInEditModeEmail = false
    @State var nameInEditModePhone = false
    
    @EnvironmentObject var userService: UserService
    @ObservedObject var viewModel: EditProfileViewModel
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("Name").modifier(SectionHeader())
                Image(systemName: "person").modifier(SFButton(color: .textHeaderPrimary))
            }) {
                HStack {
                    if nameInEditModeName {
                        TextField("\(userService.getName())", text: $userService.user.profile.name).modifier(TextFieldStyling())
                    } else {
                        Text(userService.getName()).modifier(SecondaryLabel())
                    }

                    Button(action: {
                        self.nameInEditModeName.toggle()
                    }) {
                        Text(nameInEditModeName ? "\(Image(systemName: "checkmark.circle.fill"))" : "\(Image(systemName: "pencil"))").modifier(SFButton(color: Color.sectionHeader))
                    }
                }
            }.modifier(ListRowStyling())
            Section(header: HStack {
                Text("Email").modifier(SectionHeader())
                Image(systemName: "envelope").modifier(SFButton(color: .textHeaderPrimary))
            }) {
                HStack {
                    if nameInEditModeEmail {
                        TextField("\(userService.getEmail())", text: $userService.user.email).modifier(TextFieldStyling())
                    } else {
                        Text(userService.getEmail()).modifier(SecondaryLabel())
                    }

                    Button(action: {
                        self.nameInEditModeEmail.toggle()
                    }) {
                        Text(nameInEditModeEmail ? "\(Image(systemName: "checkmark.circle.fill"))" : "\(Image(systemName: "pencil"))").modifier(SFButton(color: Color.sectionHeader))
                    }
                }
            }.modifier(ListRowStyling())
            Section(header: HStack {
                Text("Phone").modifier(SectionHeader())
                Image(systemName: "phone").modifier(SFButton(color: .textHeaderPrimary))
            }) {
                HStack {
                    if nameInEditModePhone {
                        TextField("\(userService.getPhone())", text: $userService.user.phone).modifier(TextFieldStyling())
                    } else {
                        Text(userService.getPhone()).modifier(SecondaryLabel())
                    }

                    Button(action: {
                        self.nameInEditModePhone.toggle()
                    }) {
                        Text(nameInEditModePhone ? "\(Image(systemName: "checkmark.circle.fill"))" : "\(Image(systemName: "pencil"))").modifier(SFButton(color: Color.sectionHeader))
                    }
                }

                NavigationLink(destination: EditPasswordView(viewModel: EditPasswordViewModel())) {
                    Text("Update Profile Password").modifier(SecondaryLabel())
                }
                .padding()
            }.modifier(ListRowStyling())
            .navigationBarTitle(Text("Edit Profile"), displayMode: .inline)
            //.listStyle(GroupedListStyle())
        }.listStyle(GroupedListStyle())
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(viewModel: EditProfileViewModel())
            .environmentObject(UserService())
    }
}
