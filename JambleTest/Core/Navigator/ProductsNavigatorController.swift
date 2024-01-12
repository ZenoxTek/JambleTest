//
//  ProductsNavigatorController.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

/// The `ProductsNavigatorController` takes control over the flows on the products search screen
class ProductsNavigatorController: NavigatorCoordinator {
    fileprivate let window: UIWindow
    fileprivate var searchNavigationController: UINavigationController?
    fileprivate let dependencyProvider: ProductNavigatorCoordinatorDependencyProvider

    init(window: UIWindow, dependencyProvider: ProductNavigatorCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchNavigationController = dependencyProvider.productsNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
        self.searchNavigationController = searchNavigationController
    }
}

extension ProductsNavigatorController: ProductsViewNavigator {
    func showFilterMenu() {
        // Present filter context menu
    }
    
    func showOrderByMenu() {
        // present order by context menu
    }
    
    func showDetails(forProduct productId: Int) {
        let controller = self.dependencyProvider.productDetailsController(productId)
        searchNavigationController?.pushViewController(controller, animated: true)
    }
}