//
//  OfflineDevicesViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

/*
    I deleted the remove device function from this VM since the offline devices go through the DeviceDetail VM when clicked on
 */
import Combine

final class OfflineDevicesViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?

    func setup(_ networkService: NetworkService) {
        self.networkService = networkService
    }
}

