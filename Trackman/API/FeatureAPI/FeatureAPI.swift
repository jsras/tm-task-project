//
//  FeatureAPI.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation

enum FeatureAPI: URLRequestConvertible {
    case fetchFeature

    var endpoint: String {
        switch self {
        case .fetchFeature:
            return "/deals/frontpage"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchFeature:
            return .get
        }
    }
}
