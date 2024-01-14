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
    private let service: ServiceType
    
    init(service: ServiceType) {
        self.service = service
    }
    
    func searchProduct(with query: String) -> AnyPublisher<Result<[Product], Error>, Never> {
        switch self.service {
        case is JsonServiceType:
            let jsonService: JsonServiceType = service as! JsonServiceType
            return jsonService.load(JsonResource<[ProductDTO]>(file: Constants.jsonFile))
                .map { dataDTO in
                    return .success(dataDTO.map { $0.toProduct() })
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
}
