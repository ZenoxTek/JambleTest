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
    @Inject var productsUeCase: ProductUseCase
    
    init() {
    }
}

// MARK: - ApplicationCoordinatorDependencyProvider Extension

extension ApplicationComponentsFactory: ApplicationCoordinatorDependencyProvider {
    
    func productDetailsController(_ productId: Int) -> UIViewController {
        /// TODO: Implement it if I have time
        return UIViewController()
    }

    func productsNavigationController(navigator: ProductsViewNavigator) -> UINavigationController {
        let viewModel = ProductsViewModel(useCase: productsUeCase)//, navigator: productsNavigator)
        let productsViewController = ProductsViewController(viewModel: viewModel)
        let productsNavigationController = UINavigationController(rootViewController: productsViewController)
        productsNavigationController.navigationBar.tintColor = UIColor.label
        return productsNavigationController
    }
}

