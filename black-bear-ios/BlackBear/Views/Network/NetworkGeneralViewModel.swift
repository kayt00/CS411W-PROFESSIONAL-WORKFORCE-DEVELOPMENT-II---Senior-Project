//
//  NetworkGeneralViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine

final class NetworkGeneralViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }

    func updateNetworkName() {
        
    }
    
    func updateNetworkPIN() {
        
    }

}
