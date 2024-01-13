//
//  UIViewController+Child.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 13/01/2024.
//

import UIKit

// MARK: - UIViewController Extension

extension UIViewController {
    
    /// Adds a child view controller to the current view controller's view.
    ///
    /// - Parameters:
    ///   - child: The child view controller to be added.
    ///   - parent: The parent view to which the child view will be added.
    public func add(_ child: UIViewController, to parent: UIView) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: parent.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])
        child.didMove(toParent: self)
    }

    /// Removes a child view controller from its parent.
    ///
    /// - Parameter child: The child view controller to be removed.
    public func remove(_ child: UIViewController) {
        guard child.parent != nil else {
            return
        }

        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
