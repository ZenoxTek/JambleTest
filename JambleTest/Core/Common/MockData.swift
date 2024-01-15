//
//  MockData.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation

// MARK: - MockData

class MockData {

    static let shared = MockData()
    
    private init() {}
    
    func loadProducts() -> [Product] {
        let json = """
        [
          {
            "id": 1,
            "color": "#FF5733",
            "title": "Vintage Denim Jacket",
            "price": 49.99,
            "currency": "USD",
            "size": "M"
          },
          {
            "id": 2,
            "color": "#FFC300",
            "title": "Retro Leather Boots",
            "price": 89.99,
            "currency": "USD",
            "size": "L"
          },
          {
            "id": 3,
            "color": "#DAF7A6",
            "title": "Classic Flannel Shirt",
            "price": 34.99,
            "currency": "USD",
            "size": "S"
          },
          {
            "id": 4,
            "color": "#FF5733",
            "title": "Bohemian Maxi Dress",
            "price": 59.99,
            "currency": "USD",
            "size": "M"
          },
          {
            "id": 5,
            "color": "#C70039",
            "title": "Vintage Graphic Tee",
            "price": 24.99,
            "currency": "USD",
            "size": "XL"
          },
          {
            "id": 6,
            "color": "#FFC300",
            "title": "Retro High-Waisted Jeans",
            "price": 54.99,
            "currency": "USD",
            "size": "L"
          },
          {
            "id": 7,
            "color": "#581845",
            "title": "Classic Tweed Blazer",
            "price": 79.99,
            "currency": "USD",
            "size": "M"
          },
          {
            "id": 8,
            "color": "#DAF7A6",
            "title": "Silk Scarf",
            "price": 19.99,
            "currency": "USD",
            "size": "S"
          },
          {
            "id": 9,
            "color": "#C70039",
            "title": "Vintage Wool Coat",
            "price": 99.99,
            "currency": "USD",
            "size": "XL"
          },
          {
            "id": 10,
            "color": "#581845",
            "title": "Retro Sunglasses",
            "price": 15.99,
            "currency": "USD",
            "size": "S"
          },
          {
            "id": 11,
            "color": "#FF5733",
            "title": "Leather Messenger Bag",
            "price": 110.00,
            "currency": "USD",
            "size": "M"
          },
          {
            "id": 12,
            "color": "#FFC300",
            "title": "Embroidered Denim Skirt",
            "price": 45.99,
            "currency": "USD",
            "size": "L"
          },
          {
            "id": 13,
            "color": "#DAF7A6",
            "title": "Faux Fur Vest",
            "price": 65.99,
            "currency": "USD",
            "size": "XL"
          },
          {
            "id": 14,
            "color": "#C70039",
            "title": "Retro Polka Dot Dress",
            "price": 39.99,
            "currency": "USD",
            "size": "S"
          },
          {
            "id": 15,
            "color": "#581845",
            "title": "Vintage Fedora Hat",
            "price": 29.99,
            "currency": "USD",
            "size": "M"
          }
        ]
        """

        guard let jsonData = json.data(using: .utf8) else {
            fatalError("Failed to convert JSON string to data")
        }

        do {
            let decoder = JSONDecoder()
            let products = try decoder.decode([ProductDTO].self, from: jsonData)
            return products.map { $0.toProduct() }
        } catch {
            fatalError("Failed to decode JSON: \(error)")
        }
    }
}
