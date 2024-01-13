//
//  ServicesProvider.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation

class ServicesProvider {
    /// This protocol is important to be flexible on the type of service we want to use in different situation. It can be a local service management, a network service management....
    let service: ServiceType
    
    /// Add this `ImageLoaderServiceType` Service for image downloading management. It can be used in many service situation so let it be present in the `ServicesProvider` class
    let imageLoader: ImageLoaderServiceType

    /// Preparing a network provider when we'll need to implement network feature in the app
    static func defaultNetworkProvider() -> ServicesProvider {
        let service = NetworkService()
        let imageLoader = ImageLoaderService()
        return ServicesProvider(service: service, imageLoader: imageLoader)
    }
    
    static func defaultJsonProvider() -> ServicesProvider {
        let service = JsonService()
        let imageLoader = ImageLoaderService()
        return ServicesProvider(service: service, imageLoader: imageLoader)
    }

    init(service: ServiceType, imageLoader: ImageLoaderServiceType) {
        self.service = service
        self.imageLoader = imageLoader
    }
}
