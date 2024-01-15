//
//  Product.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import UIKit

// MARK: - Product

struct Product: Identifiable {

    // MARK: - Properties
    
    let id: Int
    let color: String
    let title: String
    let price: Double
    let currency: String
    let size: String
    
    var numberOfFavorites: Int = {
        let randomNumber = Int.random(in: 0...50)
        return randomNumber
    }()
    var hasLiked: Bool = false
    var currentNumberOfFavs: Int {
        (hasLiked) ? numberOfFavorites + 1 : numberOfFavorites
    }
    
    // MARK: - Default Product
        
    static let `default`: Product = Product(
        id: -1,
        color: "Default Color",
        title: "Default Title",
        price: 0.0,
        currency: "Default Currency",
        size: "Default Size"
    )
    
    // MARK: - Computed Properties
    
    /// UIColor representation of the product color.
    var uiColor: UIColor {
        UIColor(hex: color)
    }
    
    /// ProductSize enumeration based on the product size string.
    var sizeType: ProductSize {
        ProductSize(rawValue: size) ?? ProductSize.unknown
    }
    
    /// CustomColor enumeration based on the product color string.
    var customColor: CustomColor {
        CustomColor(rawValue: color) ?? CustomColor.unknown
    }
    
    // MARK: - Methods
    
    /// Formatted price string with the given currency.
    func price(with currency: String) -> String {
        if let currencyType: CurrencyType = CurrencyType(rawValue: currency) {
            return "\(currencyType.symbol)\(price.description)"
        }
        return currency
    }
}

// MARK: - Equatable

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension Product: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
