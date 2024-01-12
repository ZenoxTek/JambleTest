//
//  ServicesProvider.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation

class ServicesProvider {
    let service: ServiceType
    let imageLoader: ImageLoaderServiceType

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
