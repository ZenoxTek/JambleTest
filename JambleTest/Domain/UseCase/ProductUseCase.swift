//
//  ProductUseCase.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine

// MARK: - ProductUseCaseType

protocol ProductUseCaseType: AutoMockable {
    
    func searchProduct(with query: LogicalRulers) -> AnyPublisher<Result<[Product], Error>, Never>

}

// MARK: - ProductUseCase

final class ProductUseCase: ProductUseCaseType {
    
    private let service: ServiceType

    init(service: ServiceType) {
        self.service = service
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
       var filteredData = (ruler.searchString.isEmpty) ? data : data.filter { product in
           product.title.lowercased().contains(ruler.searchString.lowercased())
       }

       switch ruler.filtering.0 {
       case .none:
           break // No additional filtering
       case .size:
           filteredData = filteredData.filter { product in
               product.size == ruler.filtering.1
           }
       case .color:
           filteredData = filteredData.filter { product in
               product.customColor.description == ruler.filtering.1
           }
       }

       switch ruler.sorting {
       case .none:
           break // No additional sorting
       case .asc:
           filteredData.sort(by: { $0.price < $1.price })
       case .desc:
           filteredData.sort(by: { $0.price > $1.price })
       }

       return filteredData
   }
}
