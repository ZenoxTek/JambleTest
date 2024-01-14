//
//  ProductRepository.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Foundation
import Combine

// MARK: - Product Repository

protocol ProductRepository {
    
    func searchProduct(with query: String) -> AnyPublisher<Result<[Product], Error>, Never>
}
