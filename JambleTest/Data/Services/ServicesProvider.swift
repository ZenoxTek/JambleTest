//
//  ServicesProvider.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation

// MARK: - ServicesProvider

/// A class that provides various services for the application.
class ServicesProvider {
    
    /// The main service used in the application (e.g., network service, local service).
    let service: ServiceType
    
    /// Service for managing image loading and caching.
    let imageLoader: ImageLoaderServiceType

    /// Creates a default network provider with a `NetworkService` and `ImageLoaderService`.
    static func defaultNetworkProvider() -> ServicesProvider {
        let service = NetworkService()
        let imageLoader = ImageLoaderService()
        return ServicesProvider(service: service, imageLoader: imageLoader)
    }
    
    /// Creates a default JSON provider with a `JsonService` and `ImageLoaderService`.
    static func defaultJsonProvider() -> ServicesProvider {
        let service = JsonService()
        let imageLoader = ImageLoaderService()
        return ServicesProvider(service: service, imageLoader: imageLoader)
    }

    /// Initializes the `ServicesProvider` with the specified services.
    init(service: ServiceType, imageLoader: ImageLoaderServiceType) {
        self.service = service
        self.imageLoader = imageLoader
    }
}
