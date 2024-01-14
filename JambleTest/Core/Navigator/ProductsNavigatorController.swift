//
//  ProductsNavigatorController.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

// MARK: - ProductsNavigatorController

/// The `ProductsNavigatorController` takes control over the flows on the products search screen
class ProductsNavigatorController: NavigatorCoordinator {
    
    fileprivate var searchNavigationController: UINavigationController?
    fileprivate var dependencyProvider: ProductNavigatorCoordinatorDependencyProvider
    fileprivate var window: UIWindow?
    
    init(provider: ProductNavigatorCoordinatorDependencyProvider) {
        dependencyProvider = provider
    }

    func start(window: UIWindow) {
        let searchNavigationController = dependencyProvider.productsNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
        self.searchNavigationController = searchNavigationController
        print(self.searchNavigationController ?? "Already nil")
    }
    
    deinit {
        print(self.searchNavigationController ?? "Already nil")
    }
}

// MARK: - ProductsViewNavigator

extension ProductsNavigatorController: ProductsViewNavigator {
    
    func showDetails(forProduct productId: Int) {
        print(self.searchNavigationController ?? "Already nil")
        let controller = self.dependencyProvider.productDetailsController(productId)
        searchNavigationController?.modalPresentationStyle = .formSheet
        searchNavigationController?.pushViewController(controller, animated: true)
    }
}
