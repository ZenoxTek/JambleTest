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
    
    /// called when product is liked
    let liked: AnyPublisher<(productId: Int, hasLiked: Bool), Never>
}

// MARK: - ProductDetailsState

enum ProductDetailsState {
    case nothing
    case loading
    case success(Product)
    case successLiked(Product)
    case failure(Error)
}

extension ProductDetailsState: Equatable {
    static func == (lhs: ProductDetailsState, rhs: ProductDetailsState) -> Bool {
        switch (lhs, rhs) {
        case (.nothing, .nothing): return true
        case (.loading, .loading): return true
        case (.success(let lhsProduct), .success(let rhsProduct)): return lhsProduct == rhsProduct
        case (.successLiked(let lhsProduct), .successLiked(let rhsProduct)): return lhsProduct == rhsProduct
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
