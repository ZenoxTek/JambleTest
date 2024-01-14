//
//  ProductDTO.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Foundation

// MARK: - Product DTO

struct ProductDTO: Identifiable, Codable {
    
    // MARK: - Properties
    
    let id: Int
    let color: String
    let title: String
    let price: Double
    let currency: String
    let size: String
}
