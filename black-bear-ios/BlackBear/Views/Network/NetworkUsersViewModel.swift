//
//  NetworkUsersViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine

final class NetworkUsersViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }

    func inviteNewUser() {
        // TO DO
    }
    
    func removeAuthorizedUser() {
        // TO DO
    }

}
