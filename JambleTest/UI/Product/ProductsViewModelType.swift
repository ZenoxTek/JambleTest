//
//  ProductsViewModelType.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Combine

// MARK: - ProductsViewModelInput

struct ProductsViewModelInput {
    
    /// Called when a screen becomes visible or when the search query is updated.
    let search: AnyPublisher<LogicalRulers, Never>
    
    /// Called when the user selected an item from the list
    let selection: AnyPublisher<Int, Never>
    
    /// Called when the user liked the product from list
    let liked: AnyPublisher<(Int, Bool), Never>
}

// MARK: - LogicalRulers

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

// MARK: - SortingType

enum SortingType: Int {
    case none = 0
    case asc = 1
    case desc = 2
}

// MARK: - FilteringType

enum FilteringType: Int {
    case none = 0
    case size = 1
    case color = 2
    case bookmarked = 3
}

// MARK: - ProductsState

enum ProductsState {
    case idle
    case loading
    case success([Product])
    case successLiked(Product)
    case noResults
    case failure(Error)
    case details(Int)
}

extension ProductsState: Equatable {
    static func == (lhs: ProductsState, rhs: ProductsState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsProduct), .success(let rhsProduct)): return lhsProduct == rhsProduct
        case (.successLiked(let lhsProduct), .successLiked(let rhsProduct)): return lhsProduct == rhsProduct
        case (.noResults, .noResults): return true
        case (.failure(let lhsError), .failure(let rhsError)): return lhsError.localizedDescription == rhsError.localizedDescription
        case (.details(let lid), .details(let rid)): return lid == rid
        default: return false
        }
    }
}

// MARK: - ProductsViewModelOutput

typealias ProductsViewModelOuput = AnyPublisher<ProductsState, Never>

// MARK: - ProductsViewModelType

protocol ProductsViewModelType {
    func transform(input: ProductsViewModelInput) -> ProductsViewModelOuput
    
    func loadMockData()
}
