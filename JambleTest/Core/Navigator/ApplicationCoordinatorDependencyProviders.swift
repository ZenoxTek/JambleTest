//
//  ApplicationCoordinatorDependencyProviders.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

/// The `ApplicationCoordinatorDependencyProvider` protocol defines methods to satisfy external dependencies of the ApplicationNavigatorCoordinator
protocol ApplicationCoordinatorDependencyProvider: ProductNavigatorCoordinatorDependencyProvider {}

protocol ProductNavigatorCoordinatorDependencyProvider: AnyObject {
    
    /// Creates UIViewController to search for a product
    func productsNavigationController(navigator: ProductsViewNavigator) -> UINavigationController

    // Creates UIViewController to show the details of the product with specified identifier
    func productDetailsController(_ productId: Int) -> UIViewController
}
