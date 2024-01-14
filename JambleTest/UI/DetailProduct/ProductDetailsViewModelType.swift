//
//  DetailProductViewModelType.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Foundation
import Combine

// MARK: - ProductDetailViewModelInput

struct ProductDetailsViewModelInput {
    
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
}

// MARK: - ProductDetailsState

enum ProductDetailsState {
    case loading
    case success(Product)
    case failure(Error)
}

extension ProductDetailsState: Equatable {
    static func == (lhs: ProductDetailsState, rhs: ProductDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (.success(let lhsProduct), .success(let rhsProduct)): return lhsProduct == rhsProduct
        case (.failure, .failure): return true
        default: return false
        }
    }
}

// MARK: - ProductDetailsViewModelOutput

typealias ProductDetailsViewModelOutput = AnyPublisher<ProductDetailsState, Never>

// MARK: - ProductDetailsViewModelType

protocol ProductDetailsViewModelType: AnyObject {
    func transform(input: ProductDetailsViewModelInput) -> ProductDetailsViewModelOutput
}
