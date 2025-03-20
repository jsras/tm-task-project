//
//  AppScreen.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import Foundation

enum AppScreen: Hashable, Identifiable, CaseIterable {
    var id: String { title }
    
    case left, right
    var icon: String? {
        switch self {
        case .left: return "globe"
        case .right: return "rectangle.portrait.and.arrow.right"
        }
    }
    var title: String {
        switch self {
        case .left: return "Left View (UIKit)"
        case .right: return "Right View (SwiftUI)"
        }
    }
}
