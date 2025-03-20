//
//  LeftFlowCoordinator.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import UIKit

final class LeftFlowCoordinator: FlowCoordinator {
    
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    var childCoordinator: (any Coordinator)?
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = LeftFlowViewModel(featureService: FeatureService()) { output in
            switch output {
            case let .showFeatureDetail(featureItem):
                self.showDetail(for: featureItem)
            case let .error(error):
                self.showError(error)
            }
        }
        let vc = LeftFlowViewController(viewModel: vm)
        self.navigationController.viewControllers = [vc]
    }
    
    func showDetail(for featureItem: FeatureListItemDTO) {
        let vm = LeftFlowDetailViewModel(detailFeature: featureItem) { output in
            if case .dismiss = output {
                self.navigationController.popViewController(animated: true)
            }
        }
        
        let vc = LeftFlowDetailViewController(viewModel: vm)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.navigationController.dismiss(animated: true, completion: {})
        }

        alertController.addAction(alertAction)

        // We might be called inside an async Task {}
        DispatchQueue.main.async {
            self.navigationController.present(alertController, animated: true, completion: {})
        }
    }
}
