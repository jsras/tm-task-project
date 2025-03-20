//
//  LeftFlowViewModel.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation
import Combine

enum LeftFlowViewModelInput {
    case reload, showFeatureDetail(FeatureListItemDTO)
}

enum LeftFlowViewModelOutput {
    case showFeatureDetail(FeatureListItemDTO), error(Error)
}

final class LeftFlowViewModel {
    @Published private(set) var sections: [(ListCategory, [FeatureListItemDTO])] = []
    @Published private(set) var state: ViewModelState = .loading
    
    private let featureService: FeatureService
    private let onOutput: TypeClosure<LeftFlowViewModelOutput>
    
    init(featureService: FeatureService, onOutput: @escaping TypeClosure<LeftFlowViewModelOutput>) {
        self.featureService = featureService
        self.onOutput = onOutput

        self.fetchFeatures()
    }

    func fetchFeatures() {
        state = .loading

        Task {
            do {
                let features = try await self.featureService.fetchFeatureList()
                self.sections = features.asSections()
                self.state = .ready
            } catch {
                self.state = .error(error)
                onOutput(.error(error))
            }
        }
    }
    
    func handleInput(_ input: LeftFlowViewModelInput) {
        switch input {
        case .reload:
            state = .loading
            self.sections = []
            fetchFeatures()
        case .showFeatureDetail(let feature):
            onOutput(.showFeatureDetail(feature))
        }
    }
}
