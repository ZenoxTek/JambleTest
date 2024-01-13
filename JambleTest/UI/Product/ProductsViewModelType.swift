//
//  ProductsViewModelType.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Combine

struct ProductsViewModelInput {
    /// called when a screen becomes visible or search is reset
    //let appear: AnyPublisher<Void, Never>
    // triggered when the search query is updated
    let search: AnyPublisher<LogicalRulers, Never>
    
    // Called when filter button is pressed
    //let filterOpen: AnyPublisher<Void, Never>
    // Called when order button is pressed
    //let sortByOpen: AnyPublisher<(Bool, String), Never>
}

struct LogicalRulers {
    var sorting: SortingType = SortingType.none
    var filtering: (FilteringType, String) = (FilteringType.none, "")
    var searchString: String = ""
}

extension LogicalRulers: Equatable {
    static func == (lhs: LogicalRulers, rhs: LogicalRulers) -> Bool {
        return lhs.sorting == rhs.sorting 
            && lhs.filtering == rhs.filtering
            && lhs.searchString == rhs.searchString
    }
}

enum SortingType: Int {
    case none = 0
    case asc = 1
    case desc = 2
}

enum FilteringType: Int {
    case none = 0
    case size = 1
    case color = 2
}

enum ProductsState {
    case idle
    case loading
    case success([Product])
    case noResults
    case failure(Error)
}

extension ProductsState: Equatable {
    static func == (lhs: ProductsState, rhs: ProductsState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsProduct), .success(let rhsProduct)): return lhsProduct == rhsProduct
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}

typealias ProductsViewModelOuput = AnyPublisher<ProductsState, Never>

protocol ProductsViewModelType {
    func transform(input: ProductsViewModelInput) -> ProductsViewModelOuput
    
    func loadMockData()
}
