//
//  ImageCache.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import UIKit
import ImageIO

// MARK: - ImageCacheType

/// Protocol defining an in-memory image cache.
protocol ImageCacheType: AnyObject {
    /// Returns the image associated with a given URL.
    func image(for url: URL) -> UIImage?
    /// Inserts the image of the specified URL into the cache.
    func insertImage(_ image: UIImage?, for url: URL)
    /// Removes the image of the specified URL from the cache.
    func removeImage(for url: URL)
    /// Removes all images from the cache.
    func removeAllImages()
    /// Accesses the value associated with the given key for reading and writing.
    subscript(_ url: URL) -> UIImage? { get set }
}

// MARK: - ImageCache

/// A class implementing the ImageCacheType protocol for in-memory image caching. Not needed on this project but can be useful if managing image data in the future
final class ImageCache: ImageCacheType {
    
    // MARK: - Properties
    
    /// 1st level cache that contains encoded images.
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()
    
    /// 2nd level cache that contains decoded images.
    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    
    private let lock = NSLock()
    private let config: Config
    
    // MARK: - Config
    
    /// Configuration struct for the ImageCache.
    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    // MARK: - Initialization
    
    init(config: Config = Config.defaultConfig) {
        self.config = config
    }

    // MARK: - ImageCacheType Methods
    
    func image(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // The best case scenario -> there is a decoded image in memory.
        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        // Search for image data.
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
            return decodedImage
        }
        return nil
    }

    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        let decompressedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(decompressedImage, forKey: url as AnyObject, cost: 1)
        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decompressedImage.diskSize)
    }

    func removeImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
        decodedImageCache.removeObject(forKey: url as AnyObject)
    }

    func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
        decodedImageCache.removeAllObjects()
    }

    // MARK: - Subscript
    
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}

// MARK: - UIImage Extension

fileprivate extension UIImage {

    /// Returns a decoded version of the image.
    func decodedImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        self.draw(at: CGPoint.zero)
        UIGraphicsEndImageContext()
        return self
    }

    /// Rough estimation of how much memory the image uses in bytes.
    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
