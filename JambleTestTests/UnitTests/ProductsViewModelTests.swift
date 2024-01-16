//
//  ProductsViewModelTests.swift
//  JambleTestTests
//
//  Created by Benjamin Duhieu on 15/01/2024.
//

import XCTest
import Swinject
import Combine
@testable import JambleTest

final class ProductsViewModelTests: XCTestCase {

    private let useCase = ProductUseCaseTypeMock()
    private let navigator = ProductsViewNavigatorMock()
    private var viewModel: ProductsViewModel!
    private var jsonService = JsonService()
    private var cancellables = Set<AnyCancellable>()
    
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
    
    override func setUp() {
        viewModel = ProductsViewModel(navigator: navigator)
    }

    func test_loadData_onSearch() {
        // Given
        let search = PassthroughSubject<String, Never>()
        let input = ProductsViewModelInput(search: search.eraseToAnyPublisher(), filterOrdering: .just(LogicalRulers()),
                                           selection: .empty())
        var state: ProductsState?
        let stringSearched = "Vintage Denim Jacket"
        let expectation = self.expectation(description: "products")
        var products: [Product] = []
        guard let productsDTO: [ProductDTO] = loadModelFromJSONFile(fileName: Constants.jsonFile, modelType: ProductDTO.self) else {
            print("Failed to load or decode the JSON file.")
            return
        }
        products = productsDTO.filter { $0.title.lowercased().contains(stringSearched.lowercased()) }.map { $0.toProduct() }
    
        useCase.searchProductWithReturnValue = .just(.success(products))
        viewModel.transform(input: input).sink { value in
            guard case ProductsState.success = value else { return }
            state = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // When
        search.send("Vintage Denim Jacket")

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(state!, .success(products))
    }
    
    /*func test_hasErrorState_whenDataLoadingIsFailed() {
        // Given
        let search = PassthroughSubject<String, Never>()
        let input = ProductsViewModelInput(search: search.eraseToAnyPublisher(), filterOrdering: .just(LogicalRulers()), selection: .empty())
        var state: ProductsState?

        let expectation = self.expectation(description: "products")
        useCase.searchProductWithReturnValue = .just(.failure(JsonError.invalidResponse))
        viewModel.transform(input: input).sink { value in
            if case .noResults = value {
                return
            }
            guard case .failure = value else { return }
            state = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // When
        search.send("toto")

        search.send("titi")
        // Then
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertEqual(state!, .failure(JsonError.invalidResponse))
    }*/
}
