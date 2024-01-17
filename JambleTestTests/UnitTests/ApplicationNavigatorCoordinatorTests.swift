//
//  JambleTestTests.swift
//  JambleTestTests
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import XCTest
import Swinject
@testable import JambleTest

// MARK: - ApplicationNavigatorCoordinatorTests

final class ApplicationNavigatorCoordinatorTests: XCTestCase {
    
    private lazy var applicationNavigationCoordinator = ApplicationNavigatorCoordinator(window: window, dependencyProvider: dependencyProvider)
    private let window = UIWindow()
    private let dependencyProvider = ApplicationCoordinatorDependencyProviderMock()
    
    /// Test that application flow is started correctly
    func test_startsApplicationsNavigation() {
        // GIVEN
        let rootViewController = UINavigationController()
        dependencyProvider.productsNavigationControllerNavigatorReturnValue = rootViewController

        // WHEN
        applicationNavigationCoordinator.start()

        // THEN
        XCTAssertEqual(window.rootViewController, rootViewController)
    }
}
