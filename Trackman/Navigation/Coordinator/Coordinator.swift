//
//  Coordinator.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import UIKit

protocol Coordinator: CoordinatorFinishDelegate {
    var finishDelegate: CoordinatorFinishDelegate? { get set }

    func start()
    func finish()
}

extension Coordinator {

    func finish() {
        finishDelegate?.didFinish(childCoordinator: self)
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func didFinish(childCoordinator: Coordinator)
}
