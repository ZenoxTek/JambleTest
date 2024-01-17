//
//  ProductDetailsUseCaseTests.swift
//  JambleTestTests
//
//  Created by Benjamin Duhieu on 16/01/2024.
//

import XCTest
import Combine
import Swinject
@testable import JambleTest

// MARK: - ProductDetailsUseCaseTests

class ProductDetailsUseCaseTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    let container: Container = {
        let container = Container()
        
        // Product
        container.register(ProductRepository.self) { _ in
            ProductRepositoryMock()
        }.inObjectScope(.container)
        
        container.register(ProductDetailsUseCaseType.self) { r in
            ProductDetailsUseCaseTypeMock()
        }
        
        return container
    }()
    
    // MARK: - Tests
    
    func testGetProductDetailSuccess() {
        // Given
        let productDetailsUseCase = container.resolve(ProductDetailsUseCaseType.self)! as! ProductDetailsUseCaseTypeMock
        let expectedProduct = Product(id: 1, color: "Red", title: "TestProduct", price: 19.99, currency: "USD", size: "M")
        productDetailsUseCase.getProductDetailWithReturnValue = .just(.success(expectedProduct))
        
        // When
        let expectation = XCTestExpectation(description: "Get Product Detail")
        var result: Result<Product, Error>?
        productDetailsUseCase.getProductDetail(with: 1)
            .sink(receiveCompletion: { _ in }) { receivedResult in
                result = receivedResult
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        switch result {
        case .success(let product):
            XCTAssertEqual(product, expectedProduct)
        case .none:
            XCTFail()
        case .some(.failure(_)):
            XCTFail()
        }
    }
    
    func testGetProductDetailFailure() {
        // Given
        let productDetailsUseCase = container.resolve(ProductDetailsUseCaseType.self)! as! ProductDetailsUseCaseTypeMock
        let expectedError = JsonError.invalidRequest
        productDetailsUseCase.getProductDetailWithReturnValue = .just(.failure(expectedError))
        
        // When
        let expectation = XCTestExpectation(description: "Get Product Detail Failure")
        var result: Result<Product, Error>?
        productDetailsUseCase.getProductDetail(with: 1)
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
