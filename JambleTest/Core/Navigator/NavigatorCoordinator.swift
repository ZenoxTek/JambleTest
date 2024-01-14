//
//  NavigatorCoordinator.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import UIKit

// MARK: - NavigatorCoordinator

/// A `NavigatorCoordinator` takes responsibility for coordinating view controllers and driving the flow in the application.
protocol NavigatorCoordinator: AnyObject {

    /// Starts the flow.
    func start(window: UIWindow)
}
