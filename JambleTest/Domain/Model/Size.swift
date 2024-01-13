//
//  Size.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 13/01/2024.
//

import Foundation

// MARK: - ProductSize

enum ProductSize: String, CaseIterable, Equatable {
    case extraSmall         = "XS"
    case small              = "S"
    case medium             = "M"
    case large              = "L"
    case extraLarge         = "XL"
    case extraExtraLarge    = "XXL"
    case unknown            = "Unknown"
}
