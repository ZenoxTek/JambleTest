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
        
        container.register(ProductRepositoryImpl.self) { _ in
            let serviceJsonProvider = ServicesProvider.defaultJsonProvider().service as! JsonServiceType
            let serviceNetworkProvider = ServicesProvider.defaultNetworkProvider().service as! NetworkServiceType
            return ProductRepositoryImpl(jsonService: serviceJsonProvider, networkService: serviceNetworkProvider)
        }.inObjectScope(.container)
        
        container.register(ProductUseCaseType.self) { r in
            ProductUseCaseTypeMock()
        }
        
        container.register(ProductDetailsUseCase.self) { r in
            ProductDetailsUseCase(repository: r.resolve(ProductRepositoryImpl.self)!)
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
                                           selection: .empty(), liked: .empty())
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
    
    func test_hasErrorState_whenDataLoadingIsFailed() {
        // Given
        let search = PassthroughSubject<String, Never>()
        let input = ProductsViewModelInput(search: search.eraseToAnyPublisher(), filterOrdering: .just(LogicalRulers()), selection: .empty(), liked: .empty())
        var state: ProductsState?

        /*let expectation = self.expectation(description: "movies")
        useCase.searchMoviesWithReturnValue = .just(.failure(NetworkError.invalidResponse))
        useCase.loadImageForSizeReturnValue = .just(UIImage())
        viewModel.transform(input: input).sink { value in
            guard case .failure = value else { return }
            state = value
            expectation.fulfill()
        }.store(in: &cancellables)

        // When
        search.send("joker")

        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(state!, .failure(NetworkError.invalidResponse))*/
    }
}
