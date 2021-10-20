//
//  ProfileViewModel.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 2/13/21.
//

import Combine

final class ProfileViewModel: ObservableObject, Identifiable {
    var userService: UserService?

    func setup(_ userService: UserService) {
        self.userService = userService
    }
    
    func logoutUser() {
        userService?.logoutUser()
    }
    
    
}
