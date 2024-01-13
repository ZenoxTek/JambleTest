//
//  ProductUseCase.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine

protocol ProductUseCaseType: AutoMockable {
    
    func searchProduct(with query: LogicalRulers) -> AnyPublisher<Result<[Product], Error>, Never>

}

final class ProductUseCase: ProductUseCaseType {
    
    private let service: ServiceType
    private let imageLoaderService: ImageLoaderServiceType

    init(service: ServiceType, imageLoaderService: ImageLoaderServiceType) {
        self.service = service
        self.imageLoaderService = imageLoaderService
    }

    func searchProduct(with query: LogicalRulers) -> AnyPublisher<Result<[Product], Error>, Never> {
        switch self.service {
        case is JsonServiceType:
            let jsonService: JsonServiceType = service as! JsonServiceType
            return jsonService.load(JsonResource<[Product]>(file: Constants.jsonFile))
                .map { data in
                    return .success(self.determineProducts(with: data, and: query))
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
    
    func determineProducts(with data: [Product], and ruler: LogicalRulers) -> [Product] {
        var dataTemps = (ruler.searchString.isEmpty) ? data : data.filter { product in
            product.title.lowercased().contains(ruler.searchString.lowercased())
        }
        
        dataTemps = switch ruler.filtering.0 {
        case .none:
            dataTemps
        case .size:
            dataTemps.filter { product in
                product.size == ruler.filtering.1
            }
        case .color:
            dataTemps.filter { product in
                product.customColor.description == ruler.filtering.1
            }
        }
        
        dataTemps = switch ruler.sorting {
        case .none:
            dataTemps
        case .asc:
            dataTemps.sorted(by: {
                $0.price < $1.price
            })
        case .desc:
            dataTemps.sorted(by: {
                $0.price > $1.price
            })
        }
        
        return dataTemps
    }
}
