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

    typealias DependencyProvider = ApplicationCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [NavigatorCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow.
    func start() {
        let searchFlowCoordinator = ProductsNavigatorController(window: window, dependencyProvider: self.dependencyProvider)
        childCoordinators = [searchFlowCoordinator]
        searchFlowCoordinator.start()
    }
}
