//
//  SecurityViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine

final class SecurityViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }

    func addBlacklistIP() {
       // TO DO
    }
    
    func removeBlacklistIP() {
      // TO DO
    }
}
