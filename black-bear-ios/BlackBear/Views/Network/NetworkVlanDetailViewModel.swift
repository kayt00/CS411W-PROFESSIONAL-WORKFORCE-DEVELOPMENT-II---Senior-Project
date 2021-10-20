//
//  NetworkVlanDetailViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine

final class NetworkVlanDetailViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }
// TO DO: replace with network call to remove vlan

    func removeCustomVlan(vlan: vlan) {
  /*
        guard
            let subdivisions = networkService?.subdivisions,
            let index = subdivisions.firstIndex(where: { $0.id == vlan.id })
        else { return }
        networkService?.subdivisions.remove(at: index)
        networkService?.vlanRemoved = true
 */
    }
 
}
