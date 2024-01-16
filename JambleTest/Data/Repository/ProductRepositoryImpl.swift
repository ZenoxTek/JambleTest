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
    
    
    private let jsonService: any JsonServiceType
    private let networkService: NetworkServiceType
    
    private var currentProducts = CurrentValueSubject<Result<[Product], Error>, Never>(.success([]))
    private var cancellables = Set<AnyCancellable>()
    
    init(jsonService: any JsonServiceType, networkService: NetworkServiceType) {
        self.jsonService = jsonService
        self.networkService = networkService
    }
    
    fileprivate func GetDataFromJson() {
        do {
            if try currentProducts.value.get().isEmpty {
                jsonService.load(JsonResource<[ProductDTO]>(file: Constants.jsonFile))
                    .map { dataDTO in
                        let productData = dataDTO.map { prod in
                            return prod.toProduct()
                        }
                        return productData
                    }
                    .subscribe(on: Scheduler.backgroundWorkScheduler)
                    .receive(on: Scheduler.mainScheduler)
                    .sink( receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            self.currentProducts.value = .failure(error)
                        case .finished:
                            return
                        }
                    }, receiveValue: { value in
                        self.currentProducts.value = .success(value)
                    })
                    .store(in: &cancellables)
            }
        }
        catch {
            // Nothing to do
        }
    }
    
    func getProducts(forceNetworkCall: Bool = false, page: Int = 1, numberOfItems: Int = 15) -> AnyPublisher<Result<[Product], Error>, Never> {
        if forceNetworkCall {
            // Call Network
            return .empty()
        }
        GetDataFromJson()
        return self.currentProducts.eraseToAnyPublisher()
    }
    
    func getProductDetails(with productId: Int, forceNetworkCall: Bool = false) -> AnyPublisher<Result<Product, Error>, Never> {
        if forceNetworkCall {
            return .empty()
        }
        GetDataFromJson()
        return currentProducts
            .map { result -> Result<Product, Error> in
                let product = result.map { products in
                    return products.filter({ $0.id == productId }).first
                }
                do {
                    if let prod = try product.get() {
                        return .success(prod)
                    }
                    return .failure(JsonError.invalidRequest)
                }
                catch {
                    return .failure(JsonError.invalidRequest)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func hasLiked(with productId: Int, hasLiked: Bool) {
        do {
            var products = try currentProducts.value.get()
            if !products.isEmpty && products.contains(where: { $0.id == productId }) {
                if let index = products.lastIndex(where: { $0.id == productId }) {
                    products[index].hasLiked = hasLiked
                    currentProducts.value = .success(products)
                }
            }
        }
        catch {
            // Do Nothing
        }
    }
}
