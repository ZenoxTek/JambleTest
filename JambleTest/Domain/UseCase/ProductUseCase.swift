//
//  ProductUseCase.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine
import Swinject

// MARK: - ProductUseCaseType

protocol ProductUseCaseType: AutoMockable {
    
    // MARK: Search Products
    
    /// Searches for products based on the provided logical rulers.
    /// - Parameter query: The logical rulers to apply during the search.
    /// - Returns: A publisher emitting the search result as an array of products or an error.
    func searchProduct(with query: LogicalRulers) -> AnyPublisher<Result<[Product], Error>, Never>
}

// MARK: - ProductUseCase

final class ProductUseCase: ProductUseCaseType {
    
    private let repository: ProductRepository

    // MARK: Initialization
    
    /// Initializes the ProductUseCase with the provided service.
    /// - Parameter service: The service responsible for retrieving product data.
    init(repository: ProductRepository) {
        self.repository = repository
    }

    // MARK: Search Products Implementation
    
    func searchProduct(with query: LogicalRulers) -> AnyPublisher<Result<[Product], Error>, Never> {
        return repository.searchProduct(with: query.searchString)
            .map { data in
                return .success(self.determineProducts(with: try? data.get(), and: query))
            }
            .eraseToAnyPublisher()
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

       var filteredData = (ruler.searchString.isEmpty) ? data : data.filter { product in
           product.title.lowercased().contains(ruler.searchString.lowercased())
       }

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
}
