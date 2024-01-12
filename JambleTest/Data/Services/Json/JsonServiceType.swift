//
//  JsonServiceType.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine

protocol JsonServiceType: ServiceType {

    @discardableResult
    func load<T>(_ resource: JsonResource<T>) -> AnyPublisher<T, Error>
}

/// Defines the Json service errors.
enum JsonError: Error {
    case invalidRequest
    case invalidResponse
    case jsonDecodingError(error: Error)
}
