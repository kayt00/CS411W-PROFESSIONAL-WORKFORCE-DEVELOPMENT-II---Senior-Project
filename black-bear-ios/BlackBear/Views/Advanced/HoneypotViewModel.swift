//
//  HoneypotViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/19/21.
//

import Combine

final class HoneypotViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }

    func addPort() {
      // TO DO
    }
    
    func removePort() {
     // TO DO
    }
}
