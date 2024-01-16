//
//  JsonService.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine

// MARK: - JsonService

/// A service class for loading JSON resources.
final class JsonService: JsonServiceType {
            
    // MARK: Properties
    
    /// The URL session used for data tasks.
    private let session: URLSession
    
    // MARK: Initialization
    
    /// Initializes a `JsonService` with the specified URL session.
    /// - Parameter session: The URL session for data tasks. Defaults to an ephemeral configuration.
    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }
    
    // MARK: - JsonServiceType
    
    /// Loads a JSON resource and decodes it into the specified type.
    /// - Parameter resource: The JSON resource to load.
    /// - Returns: A publisher that emits the decoded type or an error.
    @discardableResult
    func load<T>(_ resource: JsonResource<T>) -> AnyPublisher<T, Error> {
        guard let url = Bundle.main.url(forResource: resource.file, withExtension: "json") else {
            return .fail(JsonError.invalidRequest)
        }
        
        return session.dataTaskPublisher(for: url)
            .mapError { _ in JsonError.invalidRequest }
            .flatMap { data, _ -> AnyPublisher<Data, Error> in
                return .just(data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

