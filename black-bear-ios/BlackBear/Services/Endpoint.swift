//
//  Endpoint.swift
//  BlackBear
//
//  Created by ktayl023 on 3/30/21.
//NOT IN USE - CAN BE REFACTORED LATER IF TIME PERMITS

import Combine
import Foundation

/*
    The article linked below is what I used as an example for managing the URLs & endpoints - I tried implementing the 3rd suggested method which is the Endpoint struct that can be extended w/ factory methods & computed properties
    https://www.swiftbysundell.com/clips/4/
    https://www.swiftbysundell.com/articles/creating-generic-networking-apis-in-swift/
 */

struct Endpoint <Kind: EndpointKind, Response: Decodable> {
    var path: String
    var queryItems = [URLQueryItem]()
//    var requestData: Data
}

extension Endpoint {
//    func makeRequest(with data: Kind.RequestData) -> URLRequest? {
    func makeRequest(with data: Kind.RequestData) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost:8000"
        components.path = "/" + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        // If either the path or the query items passed contained
        // invalid characters, we'll get a nil URL back:
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
//
//        var request = URLRequest(url: url)
////        Kind.prepare(&request, with: data)
//        return request
    }
}

protocol EndpointKind {
    associatedtype RequestData
    
    static func prepare(_ request: inout URLRequest,
                        with data: RequestData)
}

enum EndpointKinds {
    enum Public: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with _: Void) {
            // Here we can do things like assign a custom cache
            // policy for loading our publicly available data.
            // In this example we're telling URLSession not to
            // use any locally cached data for these requests:
            request.cachePolicy = .reloadIgnoringLocalCacheData
        }
    }

    enum Private: EndpointKind {
        static func prepare(_ request: inout URLRequest,
                            with token: AccessToken) {
            // For our private endpoints, we'll require an
            // access token to be passed, which we then use to
            // assign an Authorization header to each request:
            request.addValue("Bearer \(token.rawValue)",
                forHTTPHeaderField: "Authorization"
            )
        }
    }
}

enum AccessToken: String, Codable {
    // TO DO - not quite sure how to set this one up yet
    case authToken = "xxx"
}

// MARK: User Endpoints
extension Endpoint where Kind == EndpointKinds.Public,
                         Response == String {
    static func adminUserExists(for user: User) -> Self {
        Endpoint(path: "user/admin-user-exists")
    }
    
    static func registerInitialAdmin(for user: User) -> Self {
        Endpoint(path: "auth/register-initial-admin")
    }
    
    static func addUser(for user: User) -> Self {
        Endpoint(path: "auth/add-user")
    }
    
    static func login(for user: User) -> Self {
        Endpoint(path: "auth/login")
    }
    
    static func devices(for device: DEVICE) -> Self {
        Endpoint(path: "device/all-devices")
    }
    
    static func addDevices(for device: DEVICE) -> Self {
        Endpoint(path: "device/add-device")
    }
    
    static func randomDevices(for device: DEVICE) -> Self {
        Endpoint(path: "randomData/addRandomDevices/{numberOfDevices}")
    }
    
    static func vlans(for device: DEVICE) -> Self {
        Endpoint(path: "vlan/all-vlans")
    }
    
    static func addVlans(for device: DEVICE) -> Self {
        Endpoint(path: "vlan/add-vlan")
    }
    
    static func randomVlans(for device: DEVICE) -> Self {
        Endpoint(path: "randomData/addRandomVlans/{numberOfVlans}")
    }
}

//struct UserEndpoints {
//    var urlSession = URLSession.shared
//    var currentUser: User
//
//    func registerInitialAdmin(
//        for user: User
//    ) -> AnyPublisher<String, Error> {
//        urlSession.publisher(
//            for: .registerInitialAdmin(for: currentUser), using: ()
//        )
//    }
//}



/**
 Moving this here until we have a better idea of what we're doing with it
 
 */


/*

 //
 //  NetworkLayerService.swift
 //  BlackBear
 //
 //  Created by ktayl023 on 3/30/21.
 //

 import Foundation
 import Combine

 /*
 URLs pulled from mock server's postman collection
 https://git-community.cs.odu.edu/cs411-black-bear/black-bear-backend/-/blob/master/BlackBear.postman_collection.json
 */

 /*
 Code source: https://www.swiftbysundell.com/articles/creating-generic-networking-apis-in-swift/
 */

 struct NetworkResponse<Wrapped: Decodable>: Decodable {
 var result: Wrapped
 }

 //struct ModelLoader<Model: Identifiable & Decodable> {
 //    var urlSession = URLSession.shared
 //    var urlResolver: (Model.ID) -> URL
 //
 //    func loadModel(withID id: Model.ID) -> AnyPublisher<Model, Error> {
 //        urlSession.publisher(for: urlResolver(id))
 //    }
 //}

 // TO DO
 struct NetworkError: Error {
 var invalidEndpoint: String
 }

 */
