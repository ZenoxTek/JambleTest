//
//  NoContentViewModel.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 13/01/2024.
//

import Foundation
import UIKit.UIImage

struct NoContentViewModel {
    let title: String
    let description: String?
    let image: UIImage

    static var noResults: NoContentViewModel {
        let title = String(localized: "NoProductFound")
        let description = String(localized: "SearchAgain")
        let image = UIImage(named: "icon-search") ?? UIImage()
        return NoContentViewModel(title: title, description: description, image: image.withTintColor(.black))
    }

    static var dataLoadingError: NoContentViewModel {
        let title = String(localized: "ErrorLoadResult")
        let description = String(localized: "ErrorSearchAgain")
        let image = UIImage(systemName: "exclamationmark.triangle.fill") ?? UIImage()
        return NoContentViewModel(title: title, description: description, image: image.withTintColor(.red))
    }
}
