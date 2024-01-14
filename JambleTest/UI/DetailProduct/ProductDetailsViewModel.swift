//
//  DetailProductViewModel.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Foundation
import Combine

// MARK: - ProductDetailsViewModel

final class ProductDetailsViewModel: ProductDetailsViewModelType {
    
    // MARK: - Properties

    private let productId: Int
    private let useCase: ProductDetailsUseCaseType

    // MARK: - Initialization

    init(productId: Int, useCase: ProductDetailsUseCaseType) {
        self.productId = productId
        self.useCase = useCase
    }

    // MARK: - Transform Input

    func transform(input: ProductDetailsViewModelInput) -> ProductDetailsViewModelOutput {
        let productDetails = input.appear
            .flatMap({[unowned self] _ in self.useCase.getProductDetail(with: self.productId) })
            .map({ result -> ProductDetailsState in
                switch result {
                    case .success(let product): return .success(product)
                    case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        let loading: ProductDetailsViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()

        return Publishers.Merge(loading, productDetails).removeDuplicates().eraseToAnyPublisher()
    }
}
