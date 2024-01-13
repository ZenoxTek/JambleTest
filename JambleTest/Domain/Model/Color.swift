//
//  Color.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 13/01/2024.
//

import Foundation

// MARK: - CustomColor

enum CustomColor: String, CaseIterable {
    
    case orange     = "#FF5733"
    case yellow     = "#FFC300"
    case green      = "#DAF7A6"
    case red        = "#C70039"
    case purple     = "#581845"
    case unknown    = "xxxxxxx"
    
    var description: String {
        switch self {
        case .orange:   return String(localized: "Orange")
        case .yellow:   return String(localized: "Yellow")
        case .green:    return String(localized: "Green")
        case .red:      return String(localized: "Red")
        case .purple:   return String(localized: "Purple")
        case .unknown:  return String(localized: "Unknown")
        }
    }
}
