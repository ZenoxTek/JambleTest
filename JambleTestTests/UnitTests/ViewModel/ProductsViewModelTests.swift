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
    private let likeUseCase = LikeUseCaseTypeMock()
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
    
    func test_determineProducts() {
        // Given
        let product1 = Product(id: 1, color: "#C70039", title: "Product1", price: 20.0, currency: "USD", size: "M", numberOfFavorites: 10, hasLiked: true)
        let product2 = Product(id: 2, color: "#FFC300", title: "Product2", price: 15.0, currency: "USD", size: "L", numberOfFavorites: 5, hasLiked: false)
        let product3 = Product(id: 3, color: "#DAF7A6", title: "Product3", price: 25.0, currency: "USD", size: "S", numberOfFavorites: 8, hasLiked: true)
        
        let products = [product1, product2, product3]
        
        // Create a sample LogicalRuler for testing
        let rulerNone: LogicalRulers = LogicalRulers()
        let rulerAsc: LogicalRulers = LogicalRulers(sorting: .asc, filtering: (.none, ""))
        let rulerDesc: LogicalRulers = LogicalRulers(sorting: .desc, filtering: (.none, ""))
        let rulerFilterColor: LogicalRulers = LogicalRulers(sorting: .none, filtering: (.color, "Red"))
        let rulerFilterSize: LogicalRulers = LogicalRulers(sorting: .none, filtering: (.size, "M"))
        let rulerFilterBookmarked: LogicalRulers = LogicalRulers(sorting: .none, filtering: (.bookmarked, "Bookmarked"))
        
        // When
        let resultNone = viewModel.determineProducts(with: products, and: rulerNone)
        let resultAsc = viewModel.determineProducts(with: products, and: rulerAsc)
        let resultDesc = viewModel.determineProducts(with: products, and: rulerDesc)
        let resultFilterColor = viewModel.determineProducts(with: products, and: rulerFilterColor)
        let resultFilterSize = viewModel.determineProducts(with: products, and: rulerFilterSize)
        let resultFilterBookmarked = viewModel.determineProducts(with: products, and: rulerFilterBookmarked)
        
        // Then
        XCTAssertEqual(resultNone, products) // No sorting or filtering
        XCTAssertEqual(resultAsc, [product2, product1, product3]) // Ascending sorting by price
        XCTAssertEqual(resultDesc, [product3, product1, product2]) // Descending sorting by price
        XCTAssertEqual(resultFilterColor, [product1]) // Filtering by color "Red"
        XCTAssertEqual(resultFilterSize, [product1]) // Filtering by size "M"
        XCTAssertEqual(resultFilterBookmarked, [product1, product3]) // Filtering by bookmarked
    }
}
