//
//  URLSession+Ext.swift
//  BlackBear
//
//  Created by Jeremy Fleshman on 4/3/21.
//

import Foundation
import Combine

//extension URLSession {
//    func publisher<K, R>(
//        for endpoint: Endpoint<K, R>,
//        using requestData: K.RequestData,
//        decoder: JSONDecoder = .init()
//    ) -> AnyPublisher<R, Error> {
//        guard let request = endpoint.makeRequest(with: requestData) else {
//            return Fail(
//                error: NetworkError(invalidEndpoint: "")
//            ).eraseToAnyPublisher()
//        }
//
//        return dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: NetworkResponse<R>.self, decoder: decoder)
//            .map(\.result)
//            .eraseToAnyPublisher()
//    }
//
//}
