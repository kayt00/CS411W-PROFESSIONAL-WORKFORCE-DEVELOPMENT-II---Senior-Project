//
//  LoginView.swift
//  Black Bear
//
//  Created by Katie Taylor on 2/6/21.
//

import SwiftUI
import Combine


enum ActiveAlertLogin {
    case authFailed, missingInitAdminFields
}

struct LoginView: View {
    @State var username = ""
    @State var password = ""

    @State var authDidSucceed = false
    @State var showAlert = false
    @State private var activeAlert: ActiveAlertLogin = .authFailed

    #warning("TODO: replace with network call to endpoint /user/admin-user-exists")
    @State var adminUserExists = false
    @State private var showingAdminRegisterDetails = false

    @EnvironmentObject var userService: UserService
    @EnvironmentObject var networkService: NetworkService
    @ObservedObject var viewModel: LoginViewModel
    var cancellables = Set<AnyCancellable>()

    var body: some View {
        Group {
            if !authDidSucceed {
                ZStack {
                    Color.theme.edgesIgnoringSafeArea(.all)
                    VStack {
                        LoginText()
                        LoginImage()
                        UsernameField(username: $username)
                        PasswordField(password: $password)

                        Button(action: checkLogin) {
                            LoginButtonContent()
                        }.alert(isPresented: $showAlert) {
                            switch activeAlert {
                                case .authFailed:
                                    return invalidLoginAlert()
                                case .missingInitAdminFields:
                                    return missingFieldsAlert()
                            }
                        }
                        .buttonStyle(LoginButtonStyle())
                        .disabled(username.isEmpty || password.isEmpty || !adminUserExists)

                        Spacer()

                        if !adminUserExists {
                            Button(action: { showingAdminRegisterDetails.toggle() })
                            {
                                Text("Register Initial Admin")
                            }
                            .buttonStyle(LoginButtonStyle())
                            .sheet(isPresented: $showingAdminRegisterDetails,
                                   onDismiss: { adminUserExists = true }
                            ) {
                                #warning("TODO: Extract this to a subview")
                                Text("Welcome to the Black Bear Home Guardian Portal!").modifier(RegisterAdminLabel())
                                Text("Please fill out the information below to begin securing your home network.").modifier(RegisterAdminSecondaryLabel())
                                TextField("First Name", text: $userService.user.firstName).modifier(TextFieldStyling())
                                TextField("Last Name", text: $userService.user.lastName).modifier(TextFieldStyling())
                                TextField("Username", text: $userService.user.username).modifier(OtherTextFieldStyling())
                                SecureField("Password", text: $userService.user.password).modifier(TextFieldStyling())
                                #warning("TODO: Add confirm password field w/ validation")
                                TextField("Email", text: $userService.user.email).modifier(OtherTextFieldStyling())
                                TextField("Phone Number", text: $userService.user.phone).modifier(TextFieldStyling())

                                Button(action: registerInitAdmin) {
                                    Text("Create Initial Admin")
                                }.alert(isPresented: $showAlert) {
                                    switch activeAlert {
                                        case .authFailed:
                                            return invalidLoginAlert()
                                        case .missingInitAdminFields:
                                            return missingFieldsAlert()
                                    }
                                }
                                .buttonStyle(LoginButtonStyle())
                            }
                        }

                    }.padding()
                }
            } else {
                DashboardView()
            }
        }
        .onReceive(userService.$userIsLoggedIn) {
            authDidSucceed = $0
            if authDidSucceed {
                clearFields()
            }
        }.onReceive(userService.$authDidFail) {
            activeAlert = .authFailed
            showAlert = $0
        }.onReceive(userService.$adminUserExists) {
            adminUserExists = $0
        }.onAppear {
            self.viewModel.setup(self.userService,
                                 self.networkService)
            self.viewModel.checkInitialAdminExists()
        }
    }

    func checkLogin() {
        guard !username.isEmpty, !password.isEmpty else {  return }
        viewModel.login(username: username, password: password)
    }

    func registerInitAdmin() {
        guard
            let user = viewModel.userService?.user,
            user.firstName.isEmpty == false,
            user.lastName.isEmpty == false,
            user.username.isEmpty == false,
            user.password.isEmpty == false,
            user.email.isEmpty == false,
            user.email.isEmpty == false
        else {
            activeAlert = .missingInitAdminFields
            showAlert = true
            return
        }

        viewModel.registerInitialAdmin(user: user)
        self.showingAdminRegisterDetails = false
    }

    func clearFields() {
        self.username = ""
        self.password = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}

struct LoginText: View {
    var body: some View {
        Text("Black Bear").modifier(LoginLabel())
        Text("Home Guardian").modifier(PrimaryLabel())
    }
}

struct LoginImage: View {
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .padding(.bottom, 5)
            .padding(.top, 5)
    }
}

struct UsernameField: View {
    @Binding var username: String
    
    var body: some View {
        Text("Username").modifier(SecondaryLabel())
        TextField("", text: $username).modifier(SecureFieldStyling())
    }
}

struct PasswordField: View {
    @Binding var password: String
    
    var body: some View {
        Text("Password").modifier(SecondaryLabel())
        SecureField("", text: $password).modifier(SecureFieldStyling())
    }
}

struct LoginButtonContent: View {
    var body: some View {
        Text("Login")
        //            .modifier(UpdateButton())
    }
}

// MARK: - Alerts
extension LoginView {
    private func invalidLoginAlert() -> Alert {
        return Alert(
            title: Text("Invalid Login"),
            message: Text("Reenter credentials and try again"),
            dismissButton: .default(Text("Close"))
        )
    }

    private func missingFieldsAlert() -> Alert {
        return Alert(
            title: Text("Missing Field"),
            message: Text("Please fill each field for registration"),
            dismissButton: .default(Text("Close"))
        )
    }
}
