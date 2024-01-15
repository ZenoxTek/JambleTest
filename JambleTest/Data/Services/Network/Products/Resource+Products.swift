//
//  Resource+Products.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 15/01/2024.
//

import Foundation

extension Resource {

    static func products(query: String, page: Int = 1, numberOfItems: Int = 15) -> Resource<[ProductDTO]> {
        let url = Constants.baseUrl.appendingPathComponent("/products")
        let parameters: [String : CustomStringConvertible] = [
            "api_key": Constants.apiKey,
            "query": query,
            "page": page,
            "items": numberOfItems,
            "language": Locale.preferredLanguages[0]
            ]
        return Resource<[ProductDTO]>(url: url, parameters: parameters)
    }

    static func details(productId: Int) -> Resource<ProductDTO> {
        let url = Constants.baseUrl.appendingPathComponent("/product/\(productId)")
        let parameters: [String : CustomStringConvertible] = [
            "api_key": Constants.apiKey,
            "language": Locale.preferredLanguages[0]
            ]
        return Resource<ProductDTO>(url: url, parameters: parameters)
    }
}
