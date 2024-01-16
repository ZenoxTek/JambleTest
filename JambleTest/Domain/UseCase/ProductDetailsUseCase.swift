//
//  ProductDetailsUseCase.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Foundation
import Combine

// MARK: - ProductDetailsUseCaseType

protocol ProductDetailsUseCaseType: AutoMockable {
    
    // MARK: Get Product Detail
    
    /// Searches for products based on the provided logical rulers.
    /// - Parameter query: The logical rulers to apply during the search.
    /// - Returns: A publisher emitting the search result as an array of products or an error.
    func getProductDetail(with productId: Int) -> AnyPublisher<Result<Product, Error>, Never>
    
    /// Action to like/unliked a product
    /// - Parameter productId: Id of the product liked or unliked
    /// - Parameter hasLike: Bool representing the action to either like or unliked a product
    /// - Returns: A publisher emitting the search result as an array of products or an error.
    func likedProduct(with productId: Int, hasLike: Bool)
}

// MARK: - ProductDetailsUseCase

final class ProductDetailsUseCase: ProductDetailsUseCaseType {
    
    private let repository: ProductRepositoryImpl
    
    // MARK: Initialization
    
    /// Initializes the ProductUseCase with the provided service.
    /// - Parameter repository: The repository responsible for retrieving product data.
    init(repository: ProductRepositoryImpl) {
        self.repository = repository
    }
    
    func getProductDetail(with productId: Int) -> AnyPublisher<Result<Product, Error>, Never> {
        repository.getProductDetails(with: productId)
    }
    
    func likedProduct(with productId: Int, hasLike: Bool) {
        repository.hasLiked(with: productId, hasLiked: hasLike)
    }
}
