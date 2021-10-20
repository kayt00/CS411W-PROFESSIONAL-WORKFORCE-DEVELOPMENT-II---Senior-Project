//
//  ProfileView.swift
//  Black Bear
//
//  Created by Jeremy Fleshman on 2/6/21.
// test

import SwiftUI
import Combine

struct ProfileView: View {
    @State private var weeklyAlertsOn = true
    @State private var monthlyAlertsOn = true
    @State private var smsAlertsOn = true

    #warning("TODO: Migrate business logic to ViewModel")
    @EnvironmentObject var userService: UserService
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        VStack(alignment: .leading) {
                            HStack {
                                ProfileImage()
                                Text(userService.getName()).modifier(PrimaryLabel())
                            }
                        }.modifier(ListRowStyling())

                        Section(header: HStack {
                            Text("Personal Information").modifier(SectionHeader())
                            Image(systemName: "folder.badge.person.crop").modifier(SFButton(color: .textHeaderPrimary))
                        }) {
                            HStack {
                                Text("Role:")
                                Text(userService.getRole().rawValue)
                            }.modifier(SecondaryLabel())

                            HStack {
                                Text("Email:")
                                Text(userService.getEmail())
                            }.modifier(SecondaryLabel())
                            HStack {
                                Text("Phone:")
                                Text(userService.getPhone())
                            }.modifier(SecondaryLabel())
                        }

                        Section(header: HStack {
                            Text("Notifications").modifier(SectionHeader())
                            Image(systemName: "bell.badge").modifier(SFButton(color: .textHeaderPrimary))
                        }) {
                            HStack {
                                Toggle(isOn: $weeklyAlertsOn) {
                                    Text("Weekly Summary Email").modifier(TertiaryLabel())
                                }
                                if userService.getWeeklyAlerts() {
                                    //TO DO
                                }
                            }
                            HStack {
                                Toggle(isOn: $monthlyAlertsOn) {
                                    Text("Monthly Summary Email").modifier(TertiaryLabel())
                                }
                                if userService.getMonthlyAlerts() {
                                    //TO DO
                                }
                            }
                            HStack {
                                Toggle(isOn: $smsAlertsOn) {
                                    Text("SMS Alerts on Outages").modifier(TertiaryLabel())
                                }
                                if userService.getSMSAlerts() {
                                    //TO DO
                                }
                            }
                        }
                    }
                    .modifier(ListRowStyling())
                    Button(action: { viewModel.logoutUser() }) {
                        LogOutButtonContent()
                    }.padding(.bottom, 20)

                    .navigationBarTitle(Text("Profile"), displayMode: .inline)
                   .navigationBarItems(trailing: NavigationLink(destination: EditProfileView(viewModel: EditProfileViewModel())) {Image(systemName: "pencil").modifier(SFButton(color: Color.sectionHeader))})
                    .listStyle(GroupedListStyle())
                }
            }
        }
        .onAppear {
            self.viewModel.setup(self.userService)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
            .environmentObject(UserService())
    }
}

struct ProfileImage: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
    }
}

#warning("TODO: Implement logic to logout user")
struct LogOutButtonContent: View {
    var body: some View {
        Text("Log Out")
            .modifier(RemoveButton())
            .modifier(ListRowStyling())
    }
}

