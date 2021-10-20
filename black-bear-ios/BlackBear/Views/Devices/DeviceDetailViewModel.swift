//
//  DeviceDetailViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine

final class DeviceDetailViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    // TO DO - replace with network call to device/disconnect
    func removeDevice(device: DEVICE) {
        // not sure why I'm getting the error "Cannot assign to property: 'device' is a 'let' constant" when I updated the attribute from let -> var
       // device.Status = "Offline"
        networkService?.deviceSuspended = true
    }
}
