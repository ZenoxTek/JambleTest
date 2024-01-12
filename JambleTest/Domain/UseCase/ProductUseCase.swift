//
//  ProductUseCase.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine

protocol ProductUseCaseType: AutoMockable {
    
    func searchProduct(with query: String) -> AnyPublisher<Result<[Product], Error>, Never>
    
    func fetchProducts() -> AnyPublisher<Result<[Product], Error>, Never>
    
    //func filterProducts() -> AnyPublisher<Result<Products, Error>, Never>
    
    //func orderProducts() -> AnyPublisher<Result<Products, Error> Never>

}

final class ProductUseCase: ProductUseCaseType {
    
    private let service: ServiceType
    private let imageLoaderService: ImageLoaderServiceType

    init(service: ServiceType, imageLoaderService: ImageLoaderServiceType) {
        self.service = service
        self.imageLoaderService = imageLoaderService
    }

    func searchProduct(with query: String) -> AnyPublisher<Result<[Product], Error>, Never> {
        switch self.service {
        case is JsonServiceType:
            let jsonService: JsonServiceType = service as! JsonServiceType
            return jsonService.load(JsonResource<[Product]>(file: Constants.jsonFile))
                .map { data in
                    let products = data.filter { product in
                        product.title.lowercased().contains(query.lowercased())
                    }
                    return .success(products)
                }
                .catch { error -> AnyPublisher<Result<[Product], Error>, Never> in .just(.failure(error)) }
                .subscribe(on: Scheduler.backgroundWorkScheduler)
                .receive(on: Scheduler.mainScheduler)
                .eraseToAnyPublisher()
        case is NetworkServiceType:
            return .empty()
        default:
            return .empty()
        }
    }
    
    func fetchProducts() -> AnyPublisher<Result<[Product], Error>, Never> {
        switch self.service {
        case is JsonServiceType:
            let jsonService: JsonServiceType = service as! JsonServiceType
            return jsonService.load(JsonResource<[Product]>(file: Constants.jsonFile))
                .map { .success($0) }
                .catch { error -> AnyPublisher<Result<[Product], Error>, Never> in .just(.failure(error)) }
                .subscribe(on: Scheduler.backgroundWorkScheduler)
                .receive(on: Scheduler.mainScheduler)
                .eraseToAnyPublisher()
        case is NetworkServiceType:
            return .empty()
        default:
            return .empty()
        }
    }
}
