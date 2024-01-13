//
//  ApplicationComponentFactory.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit

/// The ApplicationComponentsFactory takes responsibility of creating application components and establishing dependencies between them.
final class ApplicationComponentsFactory {
    fileprivate lazy var useCase: ProductUseCaseType = ProductUseCase(service: servicesProvider.service)

    private let servicesProvider: ServicesProvider

    init(servicesProvider: ServicesProvider = ServicesProvider.defaultJsonProvider()) {
        self.servicesProvider = servicesProvider
    }
}

extension ApplicationComponentsFactory: ApplicationCoordinatorDependencyProvider {
    
    func productDetailsController(_ productId: Int) -> UIViewController {
        ///TODO: Implement it if I have time
        return UIViewController()
    }

    func productsNavigationController(navigator: ProductsViewNavigator) -> UINavigationController {
        let viewModel = ProductsViewModel(useCase: useCase, navigator: navigator)
        let productsViewController = ProductsViewController(viewModel: viewModel)
        let productsNavigationController = UINavigationController(rootViewController: productsViewController)
        productsNavigationController.navigationBar.tintColor = UIColor.label
        return productsNavigationController
    }
}
