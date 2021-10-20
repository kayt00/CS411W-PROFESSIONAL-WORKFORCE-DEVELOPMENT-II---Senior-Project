//
//  NetworkVlansViewModel.swift
//  BlackBear
//
//  Created by ktayl023 on 2/20/21.
//

import Combine
import Foundation

final class NetworkVlansViewModel: ObservableObject, Identifiable {
    var networkService: NetworkService?
    var userService: UserService?

    func setup(_ userService: UserService, _ networkService: NetworkService) {
        self.userService = userService
        self.networkService = networkService
    }
    
    var vlanTask: AnyCancellable?
    var randomVlanTask: AnyCancellable?
    @Published var randomVlan = [vlan]()
    @Published var vlans = [vlan]()

    func allVlans() {
        var vlanRequest = URLRequest(url: .vlans)
        vlanRequest.httpMethod = "GET"
        
        guard let token = userService?.user.token else { return }
        let session = makeAuthSession(for: &vlanRequest, token: token)
        
        vlanTask = session.dataTaskPublisher(for: vlanRequest)
            .tryMap { data, response -> Data in
                try handleMap(data: data, response: response)
            }
            .decode(type: [vlan].self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<[vlan], Never> in
                print("error: \(error)")
                return Just([]).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \NetworkVlansViewModel.vlans, on: self)
    }

    func fetchRandomVlans() {
        var randomVlanRequest = URLRequest(url: .randomVlans(for: 4))

        randomVlanRequest.httpMethod = "POST"
        randomVlanRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        randomVlanTask = URLSession.shared.dataTaskPublisher(for: randomVlanRequest)
                .map { $0.data }
                .decode(type: [vlan].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .assign(to: \NetworkVlansViewModel.randomVlan, on: self)
    } 
}
