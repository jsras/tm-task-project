//
//  FeatureService.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation

class FeatureService: NetworkService<FeatureAPI>, NetworkServiceProtocol {
    func fetchFeatureList() async throws -> FeatureDTO {
        return try await request(FeatureDTO.self, request: .fetchFeature)
    }
}
