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
    @Inject var productDetailsUseCase: ProductDetailsUseCase
    
    init() {
    }
}

// MARK: - ApplicationCoordinatorDependencyProvider Extension

extension ApplicationComponentsFactory: ApplicationCoordinatorDependencyProvider {
    
    /*func productDetailsController(_ productId: Int) -> UIViewController {
        let viewModel = ProductDetailsViewModel(productId: productId, useCase: productDetailsUseCase)
        return ProductDetailsViewController(viewModel: viewModel)
    }*/

    func productsNavigationController(navigator: ProductsViewNavigator) -> UINavigationController {
        let viewModel = ProductsViewModel(useCase: productsUeCase)
        let productsViewController = ProductsViewController(viewModel: viewModel)
        let productsNavigationController = UINavigationController(rootViewController: productsViewController)
        productsNavigationController.navigationBar.tintColor = UIColor.label
        return productsNavigationController
    }
}

