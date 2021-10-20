//
//  DevicesViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine
import Foundation

final class DevicesViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?
    var userService: UserService?

    func setup(_ userService: UserService, _ networkService: NetworkService) {
        self.userService = userService
        self.networkService = networkService
    }

    // code source: https://www.iosapptemplates.com/blog/swiftui/mvvm-combine-swiftui
    var devicesRequest = URLRequest(url: .devices)
    var deviceTask: AnyCancellable?
    
    @Published var devices: [DEVICE] = []

    func allDevices() {
        devicesRequest.httpMethod = "GET"

        guard let token = userService?.user.token else { return }
        let session = makeAuthSession(for: &devicesRequest, token: token)
        
        deviceTask = session.dataTaskPublisher(for: devicesRequest)
            .tryMap { data, response -> Data in
                try handleMap(data: data, response: response)
            }
            .decode(type: [DEVICE].self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<[DEVICE], Never> in
                print("error: \(error)")
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \DevicesViewModel.devices, on: self)
    }
    
    var randomDeviceRequest = URLRequest(url: .randomDevice(for: 2))
    var randomDeviceTask: AnyCancellable?
    
    @Published var randomDevices: [DEVICE] = []
    
    func fetchRandomDevices() {
        randomDeviceRequest.httpMethod = "POST"

        randomDeviceRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        guard let token = userService?.user.token else { return }
        let session = makeAuthSession(for: &randomDeviceRequest, token: token)

        randomDeviceTask = session.dataTaskPublisher(for: randomDeviceRequest)
            .tryMap { data, response -> Data in
                try handleMap(data: data, response: response)
            }
            .decode(type: [DEVICE].self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<[DEVICE], Never> in
                print("\nerror: \(error)\n")
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \DevicesViewModel.randomDevices, on: self)
    }
    
    var pendingDevicesRequest = URLRequest(url: .pendingDevices)
    var pendingDeviceTask: AnyCancellable?
    
    @Published var pendingDevices: [DEVICE] = []

    func fetchPendingDevices() {
        pendingDevicesRequest.httpMethod = "GET"

        guard let token = userService?.user.token else { return }
        let session = makeAuthSession(for: &pendingDevicesRequest, token: token)
        
        pendingDeviceTask = session.dataTaskPublisher(for: pendingDevicesRequest)
            .tryMap { data, response -> Data in
                try handleMap(data: data, response: response)
            }
            .decode(type: [DEVICE].self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<[DEVICE], Never> in
                print("error: \(error)")
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \DevicesViewModel.pendingDevices, on: self)
    }
    
    

    
    func filterDevices() {
        // TO DO
    }
    
    func searchDevices() {
        // TO DO
    }
}



