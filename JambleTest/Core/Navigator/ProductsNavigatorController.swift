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
    
    fileprivate var dependencyProvider: ProductNavigatorCoordinatorDependencyProvider
    fileprivate var window: UIWindow?
    
    init(provider: ProductNavigatorCoordinatorDependencyProvider) {
        dependencyProvider = provider
    }

    func start(window: UIWindow) {
        let searchNavigationController = dependencyProvider.productsNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
    }
}

// MARK: - ProductsViewNavigator

extension ProductsNavigatorController: ProductsViewNavigator {
    
    func showDetails(for productId: Int, with vc: ProductsViewController) {
        let detailViewModel = ProductDetailsViewModel(productId: productId)
        let detailViewController = ProductDetailsViewController(viewModel: detailViewModel, delegate: vc as ProductsCellDelegate)
        detailViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.present(detailViewController, animated: true, completion: nil)
    }
}
