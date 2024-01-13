//
//  ImageLoaderServiceType.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//


import Foundation
import UIKit.UIImage
import Combine

// MARK: - ImageLoaderServiceType

/// Protocol defining an image loading service.
protocol ImageLoaderServiceType: AnyObject {
    /// Loads an image from the specified URL.
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}
