//
//  UserEndPoints.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation
// MARK: -
let baseUrl = "https://45434c1b-1e22-4af2-8c9f-c2d99ffa4896.mock.pstmn.io/v3"
let apiKey = ""

enum ApiEndpoints: EndpointProtocol {
    case pickupLocations
  
    var defaultHeaders: HTTPHeaders {
        var httpHeaders : [String:String] = [:]
        httpHeaders = ["Content-Type": "application/json",
                       "x-api-key":apiKey]
        return httpHeaders
    }
    
    var baseURL: URL {
        return URL(string:baseUrl)!
    }

    var path: String {
        switch self {
        case .pickupLocations:
            return "/pickup-locations"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .pickupLocations:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .pickupLocations:
            return .requestPlain
        }
    }

    var headers: HTTPHeaders? {
        return defaultHeaders
    }
}
