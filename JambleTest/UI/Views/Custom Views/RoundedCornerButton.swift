//
//  RoundedCornerButton.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 13/01/2024.
//

import UIKit

@IBDesignable
class RoundedCornerButton: UIButton {

    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
    }

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
