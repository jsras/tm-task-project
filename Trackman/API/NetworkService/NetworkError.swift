//
//  NetworkError.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case invalidResponse
    case dataConversionFailure
}
