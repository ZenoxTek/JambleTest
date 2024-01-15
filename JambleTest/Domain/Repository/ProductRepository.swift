//
//  ProductRepository.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Foundation
import Combine

// MARK: - Product Repository

protocol ProductRepository {
    
    func searchProduct(with query: String,
                       forceNetworkCall: Bool,
                       page: Int, numberOfItems:
                       Int) -> AnyPublisher<Result<[Product], Error>, Never>
    func getProductDetails(with productId: Int, forceNetworkCall: Bool) -> AnyPublisher<Result<Product, Error>, Never>
    func hasLiked(with productId: Int, hasLiked: Bool) -> AnyPublisher<Result<Product, Error>, Never>
}
