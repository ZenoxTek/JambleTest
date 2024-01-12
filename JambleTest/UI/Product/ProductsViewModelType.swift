//
//  ProductsViewModelType.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Combine

struct ProductsViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // triggered when the search query is updated
    let search: AnyPublisher<String, Never>
}

enum ProductsState {
    case idle([Product])
    case loading
    case success([Product])
    case noResults
    case failure(Error)
}

extension ProductsState: Equatable {
    static func == (lhs: ProductsState, rhs: ProductsState) -> Bool {
        switch (lhs, rhs) {
        case (.idle(let lhsProduct), .idle(let rhsProduct)): return lhsProduct == rhsProduct
        case (.loading, .loading): return true
        case (.success(let lhsProduct), .success(let rhsProduct)): return lhsProduct == rhsProduct
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias ProductsViewModelOuput = AnyPublisher<ProductsState, Never>

protocol ProductsViewModelType {
    func transform(input: ProductsViewModelInput) -> ProductsViewModelOuput
    
    func loadMockData()
}
