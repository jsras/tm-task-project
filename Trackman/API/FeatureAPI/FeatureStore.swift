//
//  FeatureStore.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation
import Observation

@Observable
final class FeatureStore {
    
    private let featureService: FeatureService
    private(set) var features: [(ListCategory, [FeatureListItemDTO])] = []
    
    init(service: FeatureService = .init()) {
        self.featureService = service
    }
    
    func loadAllSections() async throws {
        features = try await featureService.fetchFeatureList().asSections()
    }
}
