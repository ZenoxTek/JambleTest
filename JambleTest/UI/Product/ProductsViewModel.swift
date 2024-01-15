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
    
    private var navigator: ProductsViewNavigator
    @Inject private var useCase: ProductUseCaseType
    
    private var cancellables = Set<AnyCancellable>()
    
    var productItems: [Product] = []
    var productCount: Int {
        productItems.count
    }
    
    // MARK: - Initialization
    
    init(navigator: ProductsViewNavigator) {
        self.navigator = navigator
    }
    
    // MARK: - Transform Input
    
    func transform(input: ProductsViewModelInput) -> ProductsViewModelOuput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.selection
            .sink(receiveValue: { [unowned self] (productId, vc) in self.navigator.showDetails(for: productId, with: vc) })
            .store(in: &cancellables)
        
        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .removeDuplicates()
        
        let productsSearch = searchInput
            .flatMapLatest({[unowned self] query in self.useCase.searchProduct(with: query) })
            .combineLatest(input.filterOrdering)
            .map({ result, filter -> ProductsState in
                switch result {
                case .success(let products) where products.isEmpty: return .noResults
                case .success(let products): return .success(self.determineProducts(with: products, and: filter))
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let likes = input.liked
            .flatMapLatest({ [unowned self] (id, hasLike) in self.useCase.likedProduct(with: id, hasLike: hasLike) })
            .map({ result -> ProductsState in
                switch result {
                case .success(let product): return .successLiked(product)
                case .failure(_): return .idle
                }
            })
            .eraseToAnyPublisher()
                
        return Publishers.Merge(likes, productsSearch).eraseToAnyPublisher()
    }
    
    
    // MARK: Determine Filtered and Sorted Products

    /// Determines and returns products based on the provided data and logical rulers.
    /// - Parameters:
    ///   - data: The array of products to filter and sort.
    ///   - ruler: The logical rulers to apply during filtering and sorting.
    /// - Returns: An array of filtered and sorted products.
    func determineProducts(with data: [Product]?, and ruler: LogicalRulers) -> [Product] {
        guard let data else {
            return []
        }

        var filteredData = data

        switch ruler.filtering.0 {
        case .none:
            break // No additional filtering
        case .size:
            filteredData = filteredData.filter { product in
                product.size == ruler.filtering.1
            }
        case .color:
            filteredData = filteredData.filter { product in
                product.customColor.description == ruler.filtering.1
            }
        case .bookmarked:
            filteredData = filteredData.filter { product in
                if ruler.filtering.1 == Bookmarked.bookmarked.description {
                    return product.hasLiked == true
                } else if ruler.filtering.1 == Bookmarked.unbookmarked.description {
                    return product.hasLiked == false
                } else {
                    return false
                }
            }
        }

       switch ruler.sorting {
       case .none:
           break // No additional sorting
       case .asc:
           filteredData.sort(by: { $0.price < $1.price })
       case .desc:
           filteredData.sort(by: { $0.price > $1.price })
       }

       return filteredData
    }
    
    // MARK: - Navigation
    
    func showDetailView(with id: Int, vc: UIViewController) {
        let detailViewModel = ProductDetailsViewModel(productId: id)
        let detailViewController = ProductDetailsViewController(viewModel: detailViewModel, delegate: vc as! ProductsCellDelegate)
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
