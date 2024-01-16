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
    
    @Inject private var useCase: ProductDetailsUseCaseType
    @Inject private var likeUseCase: LikeUseCaseType
    
    private let productId: Int
    private var hasLikeAction: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization

    init(productId: Int) {
        self.productId = productId
    }

    // MARK: - Transform Input

    func getLikePublisher() -> AnyPublisher<(Int, Bool), Never> {
        return likeUseCase.getLikePublisher()
    }
    
    func publishLikeData(with id: Int, action: Bool) {
        likeUseCase.publishData(with: id, action: action)
    }
    
    func transform(input: ProductDetailsViewModelInput) -> ProductDetailsViewModelOutput {
        let productDetails = input.appear
            .flatMapLatest({[unowned self] _ in
               self.useCase.getProductDetail(with: self.productId)
            })
            .map({ result -> ProductDetailsState in
                switch result {
                case .success(let product) where self.hasLikeAction:
                    self.hasLikeAction = false
                    return .successLiked(product)
                case .success(let product): return .success(product)
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()
        
        likeUseCase.getLikePublisher()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    return
                case .failure(_):
                    return
                }
            }, receiveValue: { (productId, hasLike) in
                self.hasLikeAction = true
                self.useCase.likedProduct(with: productId, hasLike: hasLike)
            })
            .store(in: &cancellables)
        
        let loading: ProductDetailsViewModelOutput = input.appear.map({_ in .loading }).eraseToAnyPublisher()
        
        return Publishers.Merge(loading, productDetails).eraseToAnyPublisher()
    }
}
