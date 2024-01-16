//
//  ProductUseCaseTests.swift
//  JambleTestTests
//
//  Created by Benjamin Duhieu on 16/01/2024.
//

import Foundation
import XCTest
import Combine
import Swinject
@testable import JambleTest

class ProductUseCaseTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    let container: Container = {
        let container = Container()
    
        // Product
        
        container.register(ProductRepository.self) { _ in
            return ProductRepositoryMock()
        }.inObjectScope(.container)
        
        container.register(ProductUseCaseType.self) { _ in
            ProductUseCaseTypeMock()
        }
        
        container.register(ProductDetailsUseCaseType.self) { _ in
            ProductDetailsUseCaseTypeMock()
        }
        
        container.register(LikeUseCaseType.self) { _ in
            LikeUseCaseTypeMock()
        }
        
        return container
    }()

    // MARK: - Tests
    
    func testSearchProductSuccess() {
        // Given
        let productUseCase = container.resolve(ProductUseCaseType.self)! as! ProductUseCaseTypeMock
        let expectedProducts = [Product(id: 1, color: "Red", title: "TestProduct", price: 19.99, currency: "USD", size: "M")]
        productUseCase.searchProductWithReturnValue = .just(.success(expectedProducts))
        
        // When
        let expectation = XCTestExpectation(description: "Search Product")
        var result: Result<[Product], Error>?
        productUseCase.searchProduct(with: "Test")
            .sink(receiveCompletion: { _ in }) { receivedResult in
                result = receivedResult
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        switch result {
        case .success(let product):
            XCTAssertEqual(product, expectedProducts)
        case .none:
            XCTFail()
        case .some(.failure(_)):
            XCTFail()
        }
    }
    
    func testSearchProductFailure() {
        // Given
        let productUseCase = container.resolve(ProductUseCaseType.self)! as! ProductUseCaseTypeMock
        let expectedError = JsonError.invalidRequest
        productUseCase.searchProductWithReturnValue = .just(.failure(expectedError))
        
        // When
        let expectation = XCTestExpectation(description: "Search Product Failure")
        var result: Result<[Product], Error>?
        productUseCase.searchProduct(with: "Test")
            .sink(receiveCompletion: { _ in }) { receivedResult in
                result = receivedResult
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        switch result {
        case .success(_):
            XCTFail()
        case .none:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        }
    }
}
