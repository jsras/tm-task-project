//
//  RightFlowCoordinator.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import UIKit
import SwiftUI

final class RightFlowCoordinator: FlowCoordinator {

    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    var childCoordinator: (any Coordinator)?

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let featureStore = FeatureStore(service: FeatureService())
        let vc = UIHostingController(rootView: RightFlowScreen(onOutput: handleOutput).environment(featureStore))
        self.navigationController.setViewControllers([vc], animated: false)
    }
    
    func goToDetails(for feature: FeatureListItemDTO) {
        let viewState = RightFlowDetailViewState(feature: feature)
        let vc = UIHostingController(rootView: RightFlowDetailScreen(viewState: viewState, onOutput: handleOutput))
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func handleOutput(_ output: RightFlowScreenOutput) {
        switch output {
        case let .didSelectFeature(feature):
            self.goToDetails(for: feature)
        case .dismiss:
            self.navigationController.popViewController(animated: true)
        }
    }
}

enum RightFlowScreenOutput {
    case didSelectFeature(FeatureListItemDTO)
    case dismiss
}
