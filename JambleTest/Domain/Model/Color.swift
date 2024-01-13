//
//  Color.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 13/01/2024.
//

import Foundation

enum CustomColor: String, CaseIterable {
    
    case orange     = "#FF5733"
    case yellow     = "#FFC300"
    case green      = "#DAF7A6"
    case red        = "#C70039"
    case purple     = "#581845"
    case unknown    = "xxxxxxx"
    
    var description: String {
        switch self {
        case .orange:   "Orange"
        case .yellow:   "Yellow"
        case .green:    "Green"
        case .red:      "Red"
        case .purple:   "Purple"
        case .unknown:  "Unknown"
        }
    }
}
