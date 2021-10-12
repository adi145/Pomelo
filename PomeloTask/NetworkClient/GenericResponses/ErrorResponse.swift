//
//  ErrorResponse.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation

struct ErrorResponse: Codable {
    let errors: [ErrorMessage]?
}
