//
//  FeatureDTO.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation

struct FeatureDTO: Decodable {
    let countdown: [FeatureListItemDTO]
    let mine: [FeatureListItemDTO]
    let push: [FeatureListItemDTO]
    let others: [FeatureListItemDTO]

    func asSections() -> [(ListCategory, [FeatureListItemDTO])] {
        [
            (.countdown, countdown),
            (.mine, mine),
            (.push, push),
            (.others, others),
        ]
    }
}

struct FeatureListItemDTO: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String?

    // This property is hardcoded for now, since the API returns grey boxes which aren't that great to look at in development
    let imageUrl: String = "https://picsum.photos/400"
}

enum ListCategory: String, CaseIterable, Decodable, Hashable {
    case countdown, mine, push, others
}
