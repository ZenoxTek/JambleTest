//
//  ApplicationNavigatorCoordinator.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

// MARK: - ApplicationNavigatorCoordinator

/// The application flow coordinator. Takes responsibility for coordinating view controllers and driving the flow.
class ApplicationNavigatorCoordinator: NavigatorCoordinator {
    
    @Inject var productsNavigator: ProductsNavigatorController
    private var childCoordinators = [NavigatorCoordinator]()

    init() {
    }

    /// Creates all necessary dependencies and starts the flow.
    func start(window: UIWindow) {
        childCoordinators = [productsNavigator]
        productsNavigator.start(window: window)
    }
}
