//
//  NetworkVlansAddVlanViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 3/18/21.
//

import Combine

final class NetworkVlansAddVlanViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func addCustomVlan(vlan: VLAN) {
        networkService.subdivisions.append(vlan)
        networkService.vlanAdded = true
    }
}
