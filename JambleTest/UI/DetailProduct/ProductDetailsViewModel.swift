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
    @Inject private var useCase: ProductDetailsUseCase

    // MARK: - Initialization

    init(productId: Int) {
        self.productId = productId
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
        
        let likes = input.liked
            .flatMapLatest({ [unowned self] (id, hasLike) in self.useCase.likedProduct(with: id, hasLike: hasLike) })
            .map({ result -> ProductDetailsState in
                switch result {
                case .success(let product): return.successLiked(product)
                case .failure(_): return .nothing
                }
            })
            .eraseToAnyPublisher()
        
        let loading: ProductDetailsViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()

        let product = Publishers.Merge(likes, productDetails).eraseToAnyPublisher()
        
        return Publishers.Merge(loading, product).eraseToAnyPublisher()
    }
}
