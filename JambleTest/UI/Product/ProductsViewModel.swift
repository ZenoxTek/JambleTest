//
//  ProductsViewModel.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation

final class ProductsViewModel {
    
    var products: [Product] = []
    
    var productCount: Int {
        products.count
    }
    
    func loadMockData() {
        MockData.shared.loadProducts().forEach {
            products.append($0)
        }
    }
}
