//
//  URLComponentsExtension.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation

extension URLComponents {

    init(service: EndpointProtocol) {
        let url = service.baseURL.appendingPathComponent(service.path)
        self.init(url: url, resolvingAgainstBaseURL: false)!

        guard case let .requestParameters(_, params) = service.task, let parameters = params else {
            return
        }

        queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
