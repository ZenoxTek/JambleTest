//
//  Resource.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation

// MARK: - Resource

/// A data structure representing a network resource, including URL, parameters, and a URLRequest.
struct Resource<T: Decodable> {
    let url: URL
    let parameters: [String: CustomStringConvertible]

    /// Generates a URLRequest with the specified URL and parameters.
    var request: URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = parameters.keys.map { key in
            URLQueryItem(name: key, value: parameters[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
    }

    /// Initializes a new network resource with a URL and optional parameters.
    init(url: URL, parameters: [String: CustomStringConvertible] = [:]) {
        self.url = url
        self.parameters = parameters
    }
}
