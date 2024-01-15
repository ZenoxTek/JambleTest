//
//  UIView+Ext.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 15/01/2024.
//

import UIKit

// MARK: - UIView Extension

extension UIView {
    private var activityIndicatorTag: Int { return 999 }

    func showActivityIndicator(style: UIActivityIndicatorView.Style = .medium, color: UIColor? = nil) {
        // Check if the activity indicator is already visible
        if viewWithTag(activityIndicatorTag) != nil {
            return
        }

        // Create and configure the activity indicator
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.tag = activityIndicatorTag
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
        if let color = color {
            activityIndicator.color = color
        }

        // Add the activity indicator to the view
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    func hideActivityIndicator() {
        // Find and remove the activity indicator
        if let activityIndicator = viewWithTag(activityIndicatorTag) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
