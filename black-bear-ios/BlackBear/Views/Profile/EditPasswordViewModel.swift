//
//  EditPasswordViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine


final class EditPasswordViewModel: ObservableObject, Identifiable {
    var userService: UserService?

    func setup(_ userService: UserService) {
        self.userService = userService
    }
    
    func updatePassword(currentPassword: String, newPassword: String, newPasswordReentry: String) {
        if(currentPassword == userService?.getHashPassword() && newPassword == newPasswordReentry) {
            userService?.user.profile.hashPassword = newPassword
        } else if(currentPassword != userService?.getHashPassword()) {
           print("Password Invalid") //TO DO: alert
        }
        else if(newPassword != newPasswordReentry) {
            print("Passwords Do Not Match") //TO DO: alert
        }
    }
}
