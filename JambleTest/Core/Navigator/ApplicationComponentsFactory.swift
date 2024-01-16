//
//  ApplicationComponentFactory.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

// MARK: - ApplicationComponentsFactory

/// The ApplicationComponentsFactory takes responsibility for creating application components and establishing dependencies between them.
final class ApplicationComponentsFactory {
   
    init() {
    }
}

// MARK: - ApplicationCoordinatorDependencyProvider Extension

extension ApplicationComponentsFactory: ApplicationCoordinatorDependencyProvider {

    func productsNavigationController(navigator: ProductsNavigatorCoordinator) -> UINavigationController {
        let viewModel = ProductsViewModel(navigator: navigator)
        let productsViewController = ProductsViewController(viewModel: viewModel)
        let productsNavigationController = UINavigationController(rootViewController: productsViewController)
        productsNavigationController.navigationBar.tintColor = UIColor.label
        return productsNavigationController
    }
    
    func productDetailsController(_ productId: Int) -> UIViewController {
        let detailViewModel = ProductDetailsViewModel(productId: productId)
        return ProductDetailsViewController(viewModel: detailViewModel)
    }
}

