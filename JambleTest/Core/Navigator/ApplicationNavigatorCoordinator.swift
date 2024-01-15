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
    
    var dependencyProvider: ApplicationCoordinatorDependencyProvider
    private let window: UIWindow
    private var childCoordinators = [NavigatorCoordinator]()

    init(window: UIWindow, dependencyProvider: ApplicationCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow.
    func start() {
        let productCoordinator = ProductsNavigatorCoordinator(window: window, provider: dependencyProvider)
        childCoordinators = [productCoordinator]
        productCoordinator.start()
    }
}
