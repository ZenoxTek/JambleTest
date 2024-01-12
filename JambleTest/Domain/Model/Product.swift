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
    
    func price(with currency: String) -> String {
        if let currencyType: CurrencyType = CurrencyType(rawValue: currency) {
            return "\(currencyType.description)\(price.description)"
        }
        return currency
    }
}
