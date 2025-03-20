//
//  URLRequestConvertible.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation

protocol URLRequestConvertible {
    func makeURLRequest() throws -> URLRequest
    var endpoint: String { get }
    var method: HTTPMethod { get }
}

extension URLRequestConvertible {
    func makeURLRequest() throws -> URLRequest {
        let url = APIConfig.baseUrl + endpoint

        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addAPIKeyHeader()

        return request
    }
}

extension URLRequest {
    mutating func addAPIKeyHeader() {
        self.setValue(APIConfig.apiKey, forHTTPHeaderField: APIConfig.apiKeyHeaderName)
    }
}
