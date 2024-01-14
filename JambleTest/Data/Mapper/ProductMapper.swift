//
//  ProductMapper.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Foundation

// MARK: - ProductDTO Extension

extension ProductDTO {
    
    /// Converts the ProductDTO to a Product instance.
    ///
    /// - Returns: A Product instance.
    func toProduct() -> Product {
        return Product(id: self.id,
                       color: self.color,
                       title: self.title,
                       price: self.price,
                       currency: self.currency,
                       size: self.size)
    }
}
