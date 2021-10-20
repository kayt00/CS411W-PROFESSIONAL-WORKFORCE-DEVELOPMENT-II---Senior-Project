//
//  MFAAssignDeviceViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 3/9/21.
//


import Combine
import Foundation

final class MFAAssignDeviceViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?
    var userService: UserService?

    func setup(_ networkService: NetworkService, _ userService: UserService) {
        self.networkService = networkService
        self.userService = userService
    }
    
    func addDeviceToNetwork(device: DEVICE) {
        networkService?.devices.append(device)
        networkService?.deviceAdded = true
    }

    var mfaAssignTask: AnyCancellable?

    @Published var assigned = ""

    func addDevice(_ device: DEVICE) {
        var mfaAssignRequest = URLRequest(url: .approveDevice)
        
        let deviceApproval = MFADeviceApproval(
            deviceId: device.id,
            vlan: device.VlanId.rawValue
        )

        guard let data = try? JSONEncoder().encode(deviceApproval) else {
            print("MFA device failed to encode")
            return
        }

        mfaAssignRequest.httpMethod = "POST"
        mfaAssignRequest.setValue("application/json",
                                  forHTTPHeaderField: "Content-Type")
        mfaAssignRequest.httpBody = data

        guard let token = userService?.user.token else { return }
        let session = makeAuthSession(for: &mfaAssignRequest, token: token)

        mfaAssignTask = session.dataTaskPublisher(for: mfaAssignRequest)
            .tryMap { data, response -> Data in
                try handleMap(data: data, response: response)
            }
            .decode(type: String.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished: break
                    case let .failure(error): print("Error: \(error)")
                }
            }, receiveValue: { [weak self] someValue in
                guard let self = self else { return }
                print("mfaAssignTask received \(someValue)")
                self.networkService?.deviceAdded = true
            })
        networkService?.deviceAdded = true
    }
}
