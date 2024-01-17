//
//  ProductsNavigatorController.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

// MARK: - ProductsNavigatorController

/// The `ProductsNavigatorController` takes control over the flows on the products search screen
class ProductsNavigatorCoordinator: NavigatorCoordinator {
    
    private var dependencyProvider: ProductNavigatorCoordinatorDependencyProvider
    private var searchNavigationController: UINavigationController?
    private let window: UIWindow

    init(window: UIWindow, provider: ProductNavigatorCoordinatorDependencyProvider) {
        dependencyProvider = provider
        self.window = window
    }

    func start() {
        let searchNavigationController = dependencyProvider.productsNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
        self.searchNavigationController = searchNavigationController
    }
}

// MARK: - ProductsViewNavigator

extension ProductsNavigatorCoordinator: ProductsViewNavigator {
    
    func showDetails(for productId: Int) {
        let detailViewController = dependencyProvider.productDetailsController(productId)
        detailViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        searchNavigationController?.present(detailViewController, animated: true)
    }
}
