//
//  Product.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import UIKit

struct Product: Identifiable, Codable {
    
    let id: Int
    let color: String
    let title: String
    let price: Double
    let currency: String
    let size: String
    
    var uiColor: UIColor {
        UIColor(hex: color)
    }
    
    var sizeType: ProductSize {
        ProductSize(rawValue: size) ?? ProductSize.unknown
    }
    
    var customColor: CustomColor {
        CustomColor(rawValue: color) ?? CustomColor.unknown
    }
    
    func price(with currency: String) -> String {
        if let currencyType: CurrencyType = CurrencyType(rawValue: currency) {
            return "\(currencyType.description)\(price.description)"
        }
        return currency
    }
}

extension Product: Equatable {
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Product: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
