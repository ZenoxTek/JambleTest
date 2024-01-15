//
//  ProductRepository.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Foundation
import Combine

// MARK: - ProductRepositoryImpl

final class ProductRepositoryImpl: ProductRepository {
    private let jsonService: JsonServiceType
    private let networkService: NetworkServiceType
    
    private var products: [Product] = []
    
    init(jsonService: JsonServiceType, networkService: NetworkServiceType) {
        self.jsonService = jsonService
        self.networkService = networkService
    }
        
    func searchProduct(with query: String,
                       forceNetworkCall: Bool = false,
                       page: Int = 1, numberOfItems:
                       Int = 15) -> AnyPublisher<Result<[Product], Error>, Never> {
        if forceNetworkCall {
            // Implement Network Service using Pagination for instance
            return .empty()
        }
        if !products.isEmpty {
            return .just(.success(products))
        }
        return jsonService.load(JsonResource<[ProductDTO]>(file: Constants.jsonFile))
            .map { dataDTO in
                let productData = dataDTO.map { prod in
                    let product = prod.toProduct()
                    self.products.append(product)
                    return product
                }
                return .success(productData)
            }
            .catch { error -> AnyPublisher<Result<[Product], Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func getProductDetails(with productId: Int, forceNetworkCall: Bool = false) -> AnyPublisher<Result<Product, Error>, Never> {
        if forceNetworkCall {
            return .empty()
        }
        if !products.isEmpty {
            guard let product = products.filter({ $0.id == productId }).first else {
                return .just(.failure(JsonError.invalidResponse))
            }
            return .just(.success(product))
        }
        return jsonService.load(JsonResource<[ProductDTO]>(file: Constants.jsonFile))
            .map({ dataDTO in
                dataDTO.forEach { prod in
                    let product = prod.toProduct()
                    self.products.append(product)
                }
                guard let product = self.products.filter({ $0.id == productId }).first else {
                    return .failure(JsonError.invalidResponse)
                }
                return .success(product)
            })
            .catch { error -> AnyPublisher<Result<Product, Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.backgroundWorkScheduler)
            .receive(on: Scheduler.mainScheduler)
            .eraseToAnyPublisher()
    }
    
    func hasLiked(with productId: Int, hasLiked: Bool) -> AnyPublisher<Result<Product, Error>, Never> {
        if !products.isEmpty && products.contains(where: { $0.id == productId }) {
            if let index = products.lastIndex(where: { $0.id == productId }) {
                products[index].hasLiked = hasLiked
                return .just(.success(products[index]))
            }
        }
        return .just(.failure(JsonError.invalidResponse))
    }
}
