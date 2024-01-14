//
//  ProductsViewModel.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine
import UIKit

// MARK: - ProductsViewModel

final class ProductsViewModel: ProductsViewModelType {
    
    // MARK: - Properties
    
    @Inject private var navigator: ProductsNavigatorController
    @Inject private var detailsUseCase: ProductDetailsUseCase
    
    private let useCase: ProductUseCaseType
    private var cancellables = Set<AnyCancellable>()
    
    var productItems: [Product] = []
    var productCount: Int {
        productItems.count
    }
    
    // MARK: - Initialization
    
    init(useCase: ProductUseCaseType) {
        self.useCase = useCase
        //self.navigator = navigator
    }
    
    // MARK: - Transform Input
    
    func transform(input: ProductsViewModelInput) -> ProductsViewModelOuput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let showDetails = input.selection
            .map({ id -> ProductsState in
                .details(id)
            })
            .eraseToAnyPublisher()
        
        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .removeDuplicates()
        
        let productsSearch = searchInput
            .flatMapLatest({[unowned self] query in self.useCase.searchProduct(with: query) })
            .map({ result -> ProductsState in
                switch result {
                case .success(let products) where products.isEmpty: return .noResults
                case .success(let products): return .success(products)
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        return Publishers.Merge(showDetails, productsSearch).eraseToAnyPublisher()
    }
    
    // MARK: - Navigation
    
    func showDetailView(with id: Int, vc: UIViewController) {
        let detailViewModel = ProductDetailsViewModel(productId: id, useCase: detailsUseCase)
        let detailViewController = ProductDetailsViewController(viewModel: detailViewModel)
        detailViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.present(detailViewController, animated: true, completion: nil)
    }
    
    // MARK: - Mock Data
    
    func loadMockData() {
        MockData.shared.loadProducts().forEach {
            self.productItems.append($0)
        }
    }
}
