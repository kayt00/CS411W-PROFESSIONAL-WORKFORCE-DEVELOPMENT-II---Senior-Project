//
//  EditProfileViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine

final class EditProfileViewModel: ObservableObject, Identifiable {
    var userService: UserService?

    func setup(_ userService: UserService) {
        self.userService = userService
    }

    func updateName(name: String) {
        userService?.user.profile.name = name
    }
    
    func updateEmail(email: String) {
        userService?.user.profile.email = email
    }
    
    func updatePhone(phone: String) {
        userService?.user.profile.phone = phone
    }
}
