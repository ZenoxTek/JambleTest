//
//  ProductsCellDelegate.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 15/01/2024.
//

import Foundation

protocol ProductsCellDelegate: AnyObject {
    
    func hasLiked(with productId: Int, hasLiked: Bool)
}
