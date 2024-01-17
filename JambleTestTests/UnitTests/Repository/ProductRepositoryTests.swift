//
//  ProductRepositoryTests.swift
//  JambleTestTests
//
//  Created by Benjamin Duhieu on 16/01/2024.
//

import XCTest
import Combine
import Swinject
@testable import JambleTest

// MARK: ProductRepositoryImplTests

class ProductRepositoryImplTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    let container: Container = {
        let container = Container()
        
        // Product
        container.register(JsonServiceType.self) { _ in
            JsonServiceTypeMock<[ProductDTO]>()
        }.inObjectScope(.container)
        
        container.register(ProductRepository.self) { r in
            let serviceJsonProvider = r.resolve((any JsonServiceType).self)!
            let serviceNetworkProvider = NetworkService()
            return ProductRepositoryImpl(jsonService: serviceJsonProvider, networkService: serviceNetworkProvider)
        }.inObjectScope(.container)
        
        return container
    }()
    
    // MARK: - Tests
    
    func testGetProductsSuccess() throws {
        // Given
        let productRepository = container.resolve(ProductRepository.self)! as! ProductRepositoryImpl
        let expectedProducts = [ProductDTO(id: 1, color: "Red", title: "TestProduct", price: 19.99, currency: "USD", size: "M")]
        let jsonServiceMock = container.resolve(JsonServiceType.self)! as! JsonServiceTypeMock<[ProductDTO]>
        jsonServiceMock.loadReturnValue = Just(expectedProducts).setFailureType(to: Error.self).eraseToAnyPublisher()
               
        // When
      
        let result = try awaitPublisher(productRepository.getProducts().dropFirst().collect(1).first())
        
        // Then
        XCTAssertEqual(try result.first?.get().first?.id, expectedProducts.map { $0.toProduct() }.first?.id)
    }
    
    func testGetProductsFailure() throws {
        // Given
        let productRepository = container.resolve(ProductRepository.self)! as! ProductRepositoryImpl
        let expectedError = JsonError.invalidRequest
        let jsonServiceMock = container.resolve(JsonServiceType.self)! as! JsonServiceTypeMock<[ProductDTO]>
        jsonServiceMock.loadReturnValue = Fail(error: expectedError).eraseToAnyPublisher()
        var result: String = ""
        
        // When
        let resultPublisher = try awaitPublisher(productRepository.getProducts().dropFirst().collect(1).first())
        
        // Then
        switch resultPublisher.first {
        case .success(_):
            break
        case .failure(let error):
            result = error.localizedDescription
        case .none:
            break
        }
        XCTAssertEqual(result, expectedError.localizedDescription)
    }
    
    func testGetProductDetailsSuccess() throws {
        // Given
        let productRepository = container.resolve(ProductRepository.self)! as! ProductRepositoryImpl
        let productId = 1
        let loadProducts = [ProductDTO(id: 1, color: "Red", title: "TestProduct", price: 19.99, currency: "USD", size: "M")]
        let jsonServiceMock = container.resolve(JsonServiceType.self)! as! JsonServiceTypeMock<[ProductDTO]>
        jsonServiceMock.loadReturnValue = Just(loadProducts).setFailureType(to: Error.self).eraseToAnyPublisher()
        let expectedProduct = Product(id: productId, color: "Red", title: "TestProduct", price: 19.99, currency: "USD", size: "M")
        
        // When
        
        let result = try awaitPublisher(productRepository.getProductDetails(with: productId).dropFirst().collect(1).first())

        // Then
        XCTAssertEqual(try result.first?.get().id, expectedProduct.id)
    }
    
    func testGetProductDetailsFailure() throws {
        // Given
        let productRepository = container.resolve(ProductRepository.self)! as! ProductRepositoryImpl
        let productId = 1
        let expectedError = JsonError.invalidRequest
        let jsonServiceMock = container.resolve(JsonServiceType.self)! as! JsonServiceTypeMock<[ProductDTO]>
        jsonServiceMock.loadReturnValue = Fail(error: expectedError).eraseToAnyPublisher()
                
        var result: String = ""
        
        // When
        let resultPublisher = try awaitPublisher(productRepository.getProductDetails(with: 1).dropFirst().collect(1).first())
        
        // Then
        switch resultPublisher.first {
        case .success(_):
            break
        case .failure(let error):
            result = error.localizedDescription
        case .none:
            break
        }
        XCTAssertEqual(result, expectedError.localizedDescription)
    }
    
    func testHasLikedProduct() throws {
        // Given
        let productRepository = container.resolve(ProductRepository.self)! as! ProductRepositoryImpl
        let productId = 1
        let loadProducts = [ProductDTO(id: 1, color: "Red", title: "TestProduct", price: 19.99, currency: "USD", size: "M")]
        let jsonServiceMock = container.resolve(JsonServiceType.self)! as! JsonServiceTypeMock<[ProductDTO]>
        jsonServiceMock.loadReturnValue = Just(loadProducts).setFailureType(to: Error.self).eraseToAnyPublisher()
        let expectedProduct = Product(id: productId, color: "Red", title: "TestProduct", price: 19.99, currency: "USD", size: "M")
        
        // When
        
        var result = try awaitPublisher(productRepository.getProductDetails(with: productId).dropFirst().collect(1).first())
        productRepository.hasLiked(with: productId, hasLiked: true)
        result = try awaitPublisher(productRepository.getProductDetails(with: productId).collect(1).first())
        
        // Then
        XCTAssertTrue(try result.first?.get().hasLiked == true)
    }
}
