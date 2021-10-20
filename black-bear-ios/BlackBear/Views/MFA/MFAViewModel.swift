//
//  MFAViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 3/9/21.
//

import Combine

final class MFAViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func denyDeviceOnce() {
        // TO DO
        networkService?.deviceRejected = true
    }

    func denyDeviceForWeek() {
        // TO DO
        networkService?.deviceRejected = true
    }

    func denyDeviceIndefinitely() {
        // TO DO
        networkService?.deviceRejected = true
    }

    func authorizeDevice() {
        // TO DO
        networkService?.deviceAdded = true
    }
}
