//
//  NetworkManager.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchFeatureList() async throws -> FeatureDTO
}

class NetworkService<Request: URLRequestConvertible> {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    private func handleResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }

    func request<T: Decodable>(_ returnType: T.Type, request: Request) async throws -> T {
        let request = try request.makeURLRequest()
        
        let (data, response) = try await urlSession.data(for: request)
        
        try handleResponse(data: data, response: response)
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(returnType, from: data)
            return decodedData
        } catch {
            throw NetworkError.dataConversionFailure
        }
    }
    
    func getData(fromURL: String) async throws -> Data? {
        if let webUrl = URL(string: fromURL, encodingInvalidCharacters: false) {
            let dataSession = URLSession(configuration: .default)
            let webURLRequest = URLRequest(url: webUrl)

            guard let (response, _) = try? await dataSession.data(for: webURLRequest) else { return nil }

            return response
        }
        return nil
    }
}
