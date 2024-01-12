//
//  NavigatorCoordinator.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation

/// A `NavigatorCoordinator` takes responsibility about coordinating view controllers and driving the flow in the application.
protocol NavigatorCoordinator: AnyObject {

    /// Stars the flow
    func start()
}
