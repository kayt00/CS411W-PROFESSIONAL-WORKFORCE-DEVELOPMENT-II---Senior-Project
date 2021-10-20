//
//  NetworkService.swift
//  BlackBear
//
//  Created by ktayl023 on 3/3/21.
//

import Combine
import SwiftUI // I had to use this import to use the data type "CGFloat" required for the graph

final class NetworkService: ObservableObject {
    @Published var network: Network = Network()
    @Published var honeypot: Honeypot = Honeypot()
    var ssh: SSH = SSH()
    @Published var deviceAdded = false
    @Published var deviceSuspended = false
    @Published var deviceRejected = false
    @Published var vlanAdded = false
    @Published var vlanRemoved = false
    
    var blacklists: [Blacklist] = [
        Blacklist(countryName: "Russia"),
        Blacklist(countryName: "North Korea"),
        Blacklist(countryName: "Iran")
    ]
   
    @Published var devices = [DEVICE]() {
        didSet {
            offlineDevices = devices.filter { $0.status == .disconnected }
        }
    }
    
    @Published var offlineDevices = [DEVICE]()
    
    @Published var subdivisions = [VLAN]()
    
    @Published var uploadSpeed: Float = 50
    @Published var uploadedData: Float = 1.3
    @Published var downloadSpeed: Float = 280
    @Published var downloadedData: Float = 5.8
    @Published var onlineDevices: Int = 23
    @Published var networkStrength: String = "Weak"
    
    @Published var barValues : [[CGFloat]] =
           [
           [180,88,165,25], // download
           [30,37,32,5], // upload
           ]
    
    func getNetworkName() -> String {
        return network.networkName
    }
    
    func getNetworkPIN() -> String {
        return network.networkPIN
    }
    
}

// MARK: Endpoints

enum NetworkFailure: Error {
    case invalidServerResponse
    case encodeFailed
    case badRequest(message: String)
}

func handleMap(data: Data, response: URLResponse) throws -> Data {
    guard let httpResponse = response as? HTTPURLResponse else { throw NetworkFailure.invalidServerResponse }
    if (400...499).contains(httpResponse.statusCode) {
        let message = String(decoding: data, as: UTF8.self)
        let error = NetworkFailure.badRequest(message: message)
        print(error)
        throw error
    } else if httpResponse.statusCode != 200 {
        let error = NetworkFailure.invalidServerResponse
        print(error)
        throw error
    }
    return data
}

func makeAuthSession(for request: inout URLRequest, token: String) -> URLSession {
    request.setValue("<<access-token>>", forHTTPHeaderField: "Authentication")
    let sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.httpAdditionalHeaders = ["Authorization": "\(token)"]
    return URLSession(configuration: sessionConfiguration)
}

extension NetworkService {

    func registerInitialAdmin(for user: User) -> AnyPublisher<String, Error> {
        var request = URLRequest(url: .registerInitialAdmin)

        guard let data = try? JSONEncoder().encode(user) else {
            return Fail<String, Error>(error: NetworkFailure.invalidServerResponse)
                .eraseToAnyPublisher()
        }

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> String in
                guard let httpResponse = response as? HTTPURLResponse else { return "" }
                if httpResponse.statusCode == 400 {
                    let message = String(decoding: data, as: UTF8.self)
                    throw NetworkFailure.badRequest(message: message)
                } else if httpResponse.statusCode != 200 {
                    throw NetworkFailure.invalidServerResponse
                }
                let stringResponse = String(decoding: data, as: UTF8.self)
                return stringResponse
            }
            .eraseToAnyPublisher()
    }

    func checkInitialAdminExists() -> AnyPublisher<Bool, Error> {
        var request = URLRequest(url: .adminUserExists)

        request.httpMethod = "GET"

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Bool in
                guard let httpResponse = response as? HTTPURLResponse else { return false }
                if httpResponse.statusCode != 200 {
                    throw NetworkFailure.invalidServerResponse
                }
                let result = try JSONDecoder().decode(Bool.self, from: data)
                return result
            }
            .eraseToAnyPublisher()
    }

    func login(username: String, password: String) -> AnyPublisher<String, Error> {
        var request = URLRequest(url: .login)

        let user = User(username: username, password: password)

        guard let data = try? JSONEncoder().encode(user) else {
            return Fail<String, Error>(error: NetworkFailure.encodeFailed)
                .eraseToAnyPublisher()
        }

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                try handleMap(data: data, response: response)
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .map { $0.token }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

