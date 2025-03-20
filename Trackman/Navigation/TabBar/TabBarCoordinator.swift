//
//  TabBarCoordinator.swift
//  Trackman
//
//  Created by Jonas Rasmussen on 19/03/2025.
//

import SwiftUI
import UIKit

final class TabBarCoordinator: CompositionCoordinator {
    var finishDelegate: (any CoordinatorFinishDelegate)?
    var childCoordinators = [any Coordinator]()

    let tabBarController = UITabBarController()
    
    private(set) var leftTabCoordinator: LeftFlowCoordinator?
    private(set) var rightTabCoordinator: RightFlowCoordinator?
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let leftTabNavController = UINavigationController()
        let rightTabNavController = UINavigationController()
        
        let leftTabCoordinator = LeftFlowCoordinator(navigationController: leftTabNavController)
        let rightTabCoordinator = RightFlowCoordinator(navigationController: rightTabNavController)

        addChild(leftTabCoordinator)
        addChild(rightTabCoordinator)

        leftTabCoordinator.start()
        rightTabCoordinator.start()

        var controllers: [UINavigationController] = []
        for (index, element) in [leftTabNavController, rightTabNavController].enumerated() {
            element.tabBarItem = UITabBarItem( title: "\(AppScreen.allCases[index].title)", image: UIImage(systemName: "\(AppScreen.allCases[index].icon ?? "")"), tag: index )
            controllers.append(element)
        }

        tabBarController.viewControllers = controllers
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        self.leftTabCoordinator = leftTabCoordinator
        self.rightTabCoordinator = rightTabCoordinator
    }
}
