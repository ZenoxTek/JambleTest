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
    func searchProduct(with query: String) -> AnyPublisher<Result<[Product], Error>, Never>
    
    /// Action to like/unliked a product
    /// - Parameter productId: Id of the product liked or unliked
    /// - Parameter hasLike: Bool representing the action to either like or unliked a product
    /// - Returns: A publisher emitting the search result as an array of products or an error.
    func likedProduct(with productId: Int, hasLike: Bool) -> AnyPublisher<Result<Product, Error>, Never>
}

// MARK: - ProductUseCase

final class ProductUseCase: ProductUseCaseType {
    
    private let repository: ProductRepositoryImpl

    // MARK: Initialization
    
    /// Initializes the ProductUseCase with the provided service.
    /// - Parameter service: The service responsible for retrieving product data.
    init(repository: ProductRepositoryImpl) {
        self.repository = repository
    }

    // MARK: Search Products Implementation
    
    func searchProduct(with query: String) -> AnyPublisher<Result<[Product], Error>, Never> {
        return repository.searchProduct(with: query).map { data in
            guard let products = try? data.get() else {
                return .failure(JsonError.invalidResponse)
            }
            return .success(self.determineSearchedProducts(with: products, and: query))
        }.eraseToAnyPublisher()
    }
    
    private func determineSearchedProducts(with products: [Product], and search: String) -> [Product] {
        return (search.isEmpty) ? products : products.filter { product in
            product.title.lowercased().contains(search.lowercased())
        }
    }

    // MARK: Liked Product Implementation
    
    func likedProduct(with productId: Int, hasLike: Bool) -> AnyPublisher<Result<Product, Error>, Never> {
        return repository.hasLiked(with: productId, hasLiked: hasLike)
    }
}
