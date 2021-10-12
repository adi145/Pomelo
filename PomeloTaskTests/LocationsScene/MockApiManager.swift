//
//  MockApiManager.swift
//  PomeloTaskTests
//
//  Created by Adinarayana Machavarapu on 11/10/21.
//

import Foundation
@testable import PomeloTask

class MockApiManager: NetworkClient {
 
    var isShowErrorForLocations = false

    func request<T>(type: T.Type, service: EndpointProtocol, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        if !isShowErrorForLocations {
            isShowErrorForLocations = false
            let jsonData = LocationsMockData.getDataFromJson()
            if jsonData != nil {
                let json = try! JSONDecoder().decode(type, from: jsonData!)
                completion(.success(json))
            } else {
                completion(.failure(.generalError))
            }
        } else {
            completion(.failure(.generalError))
        }
    }
}
