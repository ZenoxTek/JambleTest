//
//  ImageLoaderServiceType.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//


import Foundation
import UIKit.UIImage
import Combine

protocol ImageLoaderServiceType: AnyObject, AutoMockable {
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never>
}
