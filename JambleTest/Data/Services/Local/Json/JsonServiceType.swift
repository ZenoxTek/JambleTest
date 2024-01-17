//
//  JsonServiceType.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine

// MARK: - JsonServiceType

protocol JsonServiceType: ServiceType {
    
    func load<T>(_ resource: JsonResource<T>) -> AnyPublisher<T, Error>
}

// MARK: - JsonError

/// Defines the Json service errors.
enum JsonError: Error {
    case invalidRequest
    case invalidResponse
    case jsonDecodingError(error: String)
}
