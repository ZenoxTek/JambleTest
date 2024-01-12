//
//  Currency.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation

struct Currency {
    let id: CurrencyType
}

enum CurrencyType: String {

    case dollar = "USD"
    case euro = "EUR"
    
    var description: String {
        switch self {
        case .dollar: "$"
        case .euro: "€"
        }
    }
}
