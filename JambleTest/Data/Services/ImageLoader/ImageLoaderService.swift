//
//  ImageLoader.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import UIKit.UIImage
import Combine

// MARK: - ImageLoaderService

/// A class implementing the ImageLoaderServiceType protocol for loading images.
final class ImageLoaderService: ImageLoaderServiceType {

    // MARK: - Properties
    
    private let cache: ImageCacheType = ImageCache()

    // MARK: - ImageLoaderServiceType Methods

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache.image(for: url) {
            return .just(image)
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: { [unowned self] image in
                guard let image = image else { return }
                self.cache.insertImage(image, for: url)
            })
            .print("Image loading \(url):")
            .eraseToAnyPublisher()
    }
}
