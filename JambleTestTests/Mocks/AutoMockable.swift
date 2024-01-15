// Generated using Sourcery 2.1.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Combine
import Swinject

@testable import JambleTest






















class ApplicationCoordinatorDependencyProviderMock: ApplicationCoordinatorDependencyProvider {




    //MARK: - productsNavigationController

    var productsNavigationControllerNavigatorCallsCount = 0
    var productsNavigationControllerNavigatorCalled: Bool {
        return productsNavigationControllerNavigatorCallsCount > 0
    }
    var productsNavigationControllerNavigatorReceivedNavigator: (ProductsNavigatorCoordinator)?
    var productsNavigationControllerNavigatorReceivedInvocations: [(ProductsNavigatorCoordinator)] = []
    var productsNavigationControllerNavigatorReturnValue: UINavigationController!
    var productsNavigationControllerNavigatorClosure: ((ProductsNavigatorCoordinator) -> UINavigationController)?

    func productsNavigationController(navigator: ProductsNavigatorCoordinator) -> UINavigationController {
        productsNavigationControllerNavigatorCallsCount += 1
        productsNavigationControllerNavigatorReceivedNavigator = navigator
        productsNavigationControllerNavigatorReceivedInvocations.append(navigator)
        if let productsNavigationControllerNavigatorClosure = productsNavigationControllerNavigatorClosure {
            return productsNavigationControllerNavigatorClosure(navigator)
        } else {
            return productsNavigationControllerNavigatorReturnValue
        }
    }

}
class ProductDetailsUseCaseTypeMock: ProductDetailsUseCaseType {




    //MARK: - getProductDetail

    var getProductDetailWithCallsCount = 0
    var getProductDetailWithCalled: Bool {
        return getProductDetailWithCallsCount > 0
    }
    var getProductDetailWithReceivedProductId: (Int)?
    var getProductDetailWithReceivedInvocations: [(Int)] = []
    var getProductDetailWithReturnValue: AnyPublisher<Result<Product, Error>, Never>!
    var getProductDetailWithClosure: ((Int) -> AnyPublisher<Result<Product, Error>, Never>)?

    func getProductDetail(with productId: Int) -> AnyPublisher<Result<Product, Error>, Never> {
        getProductDetailWithCallsCount += 1
        getProductDetailWithReceivedProductId = productId
        getProductDetailWithReceivedInvocations.append(productId)
        if let getProductDetailWithClosure = getProductDetailWithClosure {
            return getProductDetailWithClosure(productId)
        } else {
            return getProductDetailWithReturnValue
        }
    }

    //MARK: - likedProduct

    var likedProductWithHasLikeCallsCount = 0
    var likedProductWithHasLikeCalled: Bool {
        return likedProductWithHasLikeCallsCount > 0
    }
    var likedProductWithHasLikeReceivedArguments: (productId: Int, hasLike: Bool)?
    var likedProductWithHasLikeReceivedInvocations: [(productId: Int, hasLike: Bool)] = []
    var likedProductWithHasLikeReturnValue: AnyPublisher<Result<Product, Error>, Never>!
    var likedProductWithHasLikeClosure: ((Int, Bool) -> AnyPublisher<Result<Product, Error>, Never>)?

    func likedProduct(with productId: Int, hasLike: Bool) -> AnyPublisher<Result<Product, Error>, Never> {
        likedProductWithHasLikeCallsCount += 1
        likedProductWithHasLikeReceivedArguments = (productId: productId, hasLike: hasLike)
        likedProductWithHasLikeReceivedInvocations.append((productId: productId, hasLike: hasLike))
        if let likedProductWithHasLikeClosure = likedProductWithHasLikeClosure {
            return likedProductWithHasLikeClosure(productId, hasLike)
        } else {
            return likedProductWithHasLikeReturnValue
        }
    }

}
class ProductNavigatorCoordinatorDependencyProviderMock: ProductNavigatorCoordinatorDependencyProvider {




    //MARK: - productsNavigationController

    var productsNavigationControllerNavigatorCallsCount = 0
    var productsNavigationControllerNavigatorCalled: Bool {
        return productsNavigationControllerNavigatorCallsCount > 0
    }
    var productsNavigationControllerNavigatorReceivedNavigator: (ProductsNavigatorCoordinator)?
    var productsNavigationControllerNavigatorReceivedInvocations: [(ProductsNavigatorCoordinator)] = []
    var productsNavigationControllerNavigatorReturnValue: UINavigationController!
    var productsNavigationControllerNavigatorClosure: ((ProductsNavigatorCoordinator) -> UINavigationController)?

    func productsNavigationController(navigator: ProductsNavigatorCoordinator) -> UINavigationController {
        productsNavigationControllerNavigatorCallsCount += 1
        productsNavigationControllerNavigatorReceivedNavigator = navigator
        productsNavigationControllerNavigatorReceivedInvocations.append(navigator)
        if let productsNavigationControllerNavigatorClosure = productsNavigationControllerNavigatorClosure {
            return productsNavigationControllerNavigatorClosure(navigator)
        } else {
            return productsNavigationControllerNavigatorReturnValue
        }
    }

}
class ProductUseCaseTypeMock: ProductUseCaseType {




    //MARK: - searchProduct

    var searchProductWithCallsCount = 0
    var searchProductWithCalled: Bool {
        return searchProductWithCallsCount > 0
    }
    var searchProductWithReceivedQuery: (String)?
    var searchProductWithReceivedInvocations: [(String)] = []
    var searchProductWithReturnValue: AnyPublisher<Result<[Product], Error>, Never>!
    var searchProductWithClosure: ((String) -> AnyPublisher<Result<[Product], Error>, Never>)?

    func searchProduct(with query: String) -> AnyPublisher<Result<[Product], Error>, Never> {
        searchProductWithCallsCount += 1
        searchProductWithReceivedQuery = query
        searchProductWithReceivedInvocations.append(query)
        if let searchProductWithClosure = searchProductWithClosure {
            return searchProductWithClosure(query)
        } else {
            return searchProductWithReturnValue
        }
    }

    //MARK: - likedProduct

    var likedProductWithHasLikeCallsCount = 0
    var likedProductWithHasLikeCalled: Bool {
        return likedProductWithHasLikeCallsCount > 0
    }
    var likedProductWithHasLikeReceivedArguments: (productId: Int, hasLike: Bool)?
    var likedProductWithHasLikeReceivedInvocations: [(productId: Int, hasLike: Bool)] = []
    var likedProductWithHasLikeReturnValue: AnyPublisher<Result<Product, Error>, Never>!
    var likedProductWithHasLikeClosure: ((Int, Bool) -> AnyPublisher<Result<Product, Error>, Never>)?

    func likedProduct(with productId: Int, hasLike: Bool) -> AnyPublisher<Result<Product, Error>, Never> {
        likedProductWithHasLikeCallsCount += 1
        likedProductWithHasLikeReceivedArguments = (productId: productId, hasLike: hasLike)
        likedProductWithHasLikeReceivedInvocations.append((productId: productId, hasLike: hasLike))
        if let likedProductWithHasLikeClosure = likedProductWithHasLikeClosure {
            return likedProductWithHasLikeClosure(productId, hasLike)
        } else {
            return likedProductWithHasLikeReturnValue
        }
    }

}
class ProductsViewNavigatorMock: ProductsViewNavigator {




}
