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
    
    fileprivate var dependencyProvider: ProductNavigatorCoordinatorDependencyProvider
    fileprivate let window: UIWindow

    init(window: UIWindow, provider: ProductNavigatorCoordinatorDependencyProvider) {
        dependencyProvider = provider
        self.window = window
    }

    func start() {
        let searchNavigationController = dependencyProvider.productsNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
    }
}

// MARK: - ProductsViewNavigator

extension ProductsNavigatorCoordinator: ProductsViewNavigator {
    
    func showDetails(for productId: Int, with vc: ProductsViewController) {
        let detailViewModel = ProductDetailsViewModel(productId: productId)
        let detailViewController = ProductDetailsViewController(viewModel: detailViewModel, delegate: vc as ProductsCellDelegate)
        detailViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.present(detailViewController, animated: true, completion: nil)
    }
}
