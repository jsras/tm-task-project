//
//  RightFlowDetailScreenViewState.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 20/03/2025.
//

import SwiftUI
import Observation

@Observable
final class RightFlowDetailViewState {
    let imageURL: URL?
    let title: String
    let subtitle: String
    
    init(feature: FeatureListItemDTO) {
        self.imageURL = URL(string: feature.imageUrl)
        self.title = feature.name
        self.subtitle = feature.description ?? "No current description available."
    }
}
