//
//  Currency.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation

// MARK: - Currency

struct Currency {
    let type: CurrencyType
}

// MARK: - CurrencyType

enum CurrencyType: String {

    case dollar = "USD"
    case euro   = "EUR"
    
    var symbol: String {
        switch self {
        case .dollar: return "$"
        case .euro: return "€"
        }
    }
}
