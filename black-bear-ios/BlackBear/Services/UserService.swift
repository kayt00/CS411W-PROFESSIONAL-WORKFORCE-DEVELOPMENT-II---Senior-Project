//
//  UserService.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 2/11/21.
//

import Combine

final class UserService: ObservableObject {
    @Published var userIsLoggedIn = false
    @Published var authDidFail = false
    @Published var adminUserExists = false
    @Published var username = ""
    @Published var password = ""
    @Published var user = User()

    private var disposables = Set<AnyCancellable>()

    func isUserLoggedIn() -> Bool {
        return userIsLoggedIn
    }

    func getName() -> String {
        return user.profile.name
    }
    
    func getHashPassword() -> String {
        return user.profile.hashPassword
    }
    
    func getPhone() -> String {
        return user.profile.phone
    }
 
    func getEmail() -> String {
        return user.profile.email
    }
    
    func getRole() -> UserRole {
        return user.profile.role
    }
    
    func getWeeklyAlerts() -> Bool {
        return user.profile.weeklyAlertsOn
    }
    
    func getMonthlyAlerts() -> Bool {
        return user.profile.monthlyAlertsOn
    }
    
    func getSMSAlerts() -> Bool {
        return user.profile.smsAlertsOn
    }
    
    func logoutUser() {
        userIsLoggedIn = false
    }

    func setUserLoggedIn() {
        self.userIsLoggedIn = true
    }
}
