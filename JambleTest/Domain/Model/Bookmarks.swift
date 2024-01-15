//
//  Bookmarks.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 15/01/2024.
//

import Foundation

// MARK: - Bookmarked

enum Bookmarked: String, CaseIterable {
    case unknown        = "unknown"
    case bookmarked     = "Yes"
    case unbookmarked   = "No"
    
    var description: String {
        switch self {
        case .unknown:      return String(localized: "Unknown")
        case .bookmarked:   return String(localized: "Bookmarked")
        case .unbookmarked: return String(localized: "Unbookmarked")
        }
    }
    
    var displayedButton: String {
        switch self {
        case .unknown:      return String(localized: "Unknown")
        case .bookmarked:   return String(localized: "Yes")
        case .unbookmarked: return String(localized: "No")
        }
    }
}
