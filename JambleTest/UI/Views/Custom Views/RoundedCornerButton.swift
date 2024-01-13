//
//  RoundedCornerButton.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 13/01/2024.
//

import UIKit

// MARK: - RoundedCornerButton

@IBDesignable
class RoundedCornerButton: UIButton {

    // MARK: Overrides

    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
    }

    // MARK: Inspectable Properties

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var cornerCurve: CALayerCornerCurve = .continuous {
        didSet {
            self.layer.cornerCurve = cornerCurve
        }
    }
}

