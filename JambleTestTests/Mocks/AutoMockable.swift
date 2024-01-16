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

    //MARK: - productDetailsController

    var productDetailsControllerCallsCount = 0
    var productDetailsControllerCalled: Bool {
        return productDetailsControllerCallsCount > 0
    }
    var productDetailsControllerReceivedProductId: (Int)?
    var productDetailsControllerReceivedInvocations: [(Int)] = []
    var productDetailsControllerReturnValue: UIViewController!
    var productDetailsControllerClosure: ((Int) -> UIViewController)?

    func productDetailsController(_ productId: Int) -> UIViewController {
        productDetailsControllerCallsCount += 1
        productDetailsControllerReceivedProductId = productId
        productDetailsControllerReceivedInvocations.append(productId)
        if let productDetailsControllerClosure = productDetailsControllerClosure {
            return productDetailsControllerClosure(productId)
        } else {
            return productDetailsControllerReturnValue
        }
    }

}
class LikeUseCaseTypeMock: LikeUseCaseType {




    //MARK: - getLikePublisher

    var getLikePublisherCallsCount = 0
    var getLikePublisherCalled: Bool {
        return getLikePublisherCallsCount > 0
    }
    var getLikePublisherReturnValue: AnyPublisher<(Int, Bool), Never>!
    var getLikePublisherClosure: (() -> AnyPublisher<(Int, Bool), Never>)?

    func getLikePublisher() -> AnyPublisher<(Int, Bool), Never> {
        getLikePublisherCallsCount += 1
        if let getLikePublisherClosure = getLikePublisherClosure {
            return getLikePublisherClosure()
        } else {
            return getLikePublisherReturnValue
        }
    }

    //MARK: - publishData

    var publishDataWithActionCallsCount = 0
    var publishDataWithActionCalled: Bool {
        return publishDataWithActionCallsCount > 0
    }
    var publishDataWithActionReceivedArguments: (id: Int, action: Bool)?
    var publishDataWithActionReceivedInvocations: [(id: Int, action: Bool)] = []
    var publishDataWithActionClosure: ((Int, Bool) -> Void)?

    func publishData(with id: Int, action: Bool) {
        publishDataWithActionCallsCount += 1
        publishDataWithActionReceivedArguments = (id: id, action: action)
        publishDataWithActionReceivedInvocations.append((id: id, action: action))
        publishDataWithActionClosure?(id, action)
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
    var likedProductWithHasLikeClosure: ((Int, Bool) -> Void)?

    func likedProduct(with productId: Int, hasLike: Bool) {
        likedProductWithHasLikeCallsCount += 1
        likedProductWithHasLikeReceivedArguments = (productId: productId, hasLike: hasLike)
        likedProductWithHasLikeReceivedInvocations.append((productId: productId, hasLike: hasLike))
        likedProductWithHasLikeClosure?(productId, hasLike)
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

    //MARK: - productDetailsController

    var productDetailsControllerCallsCount = 0
    var productDetailsControllerCalled: Bool {
        return productDetailsControllerCallsCount > 0
    }
    var productDetailsControllerReceivedProductId: (Int)?
    var productDetailsControllerReceivedInvocations: [(Int)] = []
    var productDetailsControllerReturnValue: UIViewController!
    var productDetailsControllerClosure: ((Int) -> UIViewController)?

    func productDetailsController(_ productId: Int) -> UIViewController {
        productDetailsControllerCallsCount += 1
        productDetailsControllerReceivedProductId = productId
        productDetailsControllerReceivedInvocations.append(productId)
        if let productDetailsControllerClosure = productDetailsControllerClosure {
            return productDetailsControllerClosure(productId)
        } else {
            return productDetailsControllerReturnValue
        }
    }

}
class ProductRepositoryMock: ProductRepository {




    //MARK: - getProductDetails

    var getProductDetailsWithForceNetworkCallCallsCount = 0
    var getProductDetailsWithForceNetworkCallCalled: Bool {
        return getProductDetailsWithForceNetworkCallCallsCount > 0
    }
    var getProductDetailsWithForceNetworkCallReceivedArguments: (productId: Int, forceNetworkCall: Bool)?
    var getProductDetailsWithForceNetworkCallReceivedInvocations: [(productId: Int, forceNetworkCall: Bool)] = []
    var getProductDetailsWithForceNetworkCallReturnValue: AnyPublisher<Result<Product, Error>, Never>!
    var getProductDetailsWithForceNetworkCallClosure: ((Int, Bool) -> AnyPublisher<Result<Product, Error>, Never>)?

    func getProductDetails(with productId: Int, forceNetworkCall: Bool) -> AnyPublisher<Result<Product, Error>, Never> {
        getProductDetailsWithForceNetworkCallCallsCount += 1
        getProductDetailsWithForceNetworkCallReceivedArguments = (productId: productId, forceNetworkCall: forceNetworkCall)
        getProductDetailsWithForceNetworkCallReceivedInvocations.append((productId: productId, forceNetworkCall: forceNetworkCall))
        if let getProductDetailsWithForceNetworkCallClosure = getProductDetailsWithForceNetworkCallClosure {
            return getProductDetailsWithForceNetworkCallClosure(productId, forceNetworkCall)
        } else {
            return getProductDetailsWithForceNetworkCallReturnValue
        }
    }

    //MARK: - getProducts

    var getProductsForceNetworkCallPageNumberOfItemsCallsCount = 0
    var getProductsForceNetworkCallPageNumberOfItemsCalled: Bool {
        return getProductsForceNetworkCallPageNumberOfItemsCallsCount > 0
    }
    var getProductsForceNetworkCallPageNumberOfItemsReceivedArguments: (forceNetworkCall: Bool, page: Int, numberOfItems: Int)?
    var getProductsForceNetworkCallPageNumberOfItemsReceivedInvocations: [(forceNetworkCall: Bool, page: Int, numberOfItems: Int)] = []
    var getProductsForceNetworkCallPageNumberOfItemsReturnValue: AnyPublisher<Result<[Product], Error>, Never>!
    var getProductsForceNetworkCallPageNumberOfItemsClosure: ((Bool, Int, Int) -> AnyPublisher<Result<[Product], Error>, Never>)?

    func getProducts(forceNetworkCall: Bool, page: Int, numberOfItems: Int) -> AnyPublisher<Result<[Product], Error>, Never> {
        getProductsForceNetworkCallPageNumberOfItemsCallsCount += 1
        getProductsForceNetworkCallPageNumberOfItemsReceivedArguments = (forceNetworkCall: forceNetworkCall, page: page, numberOfItems: numberOfItems)
        getProductsForceNetworkCallPageNumberOfItemsReceivedInvocations.append((forceNetworkCall: forceNetworkCall, page: page, numberOfItems: numberOfItems))
        if let getProductsForceNetworkCallPageNumberOfItemsClosure = getProductsForceNetworkCallPageNumberOfItemsClosure {
            return getProductsForceNetworkCallPageNumberOfItemsClosure(forceNetworkCall, page, numberOfItems)
        } else {
            return getProductsForceNetworkCallPageNumberOfItemsReturnValue
        }
    }

    //MARK: - hasLiked

    var hasLikedWithHasLikedCallsCount = 0
    var hasLikedWithHasLikedCalled: Bool {
        return hasLikedWithHasLikedCallsCount > 0
    }
    var hasLikedWithHasLikedReceivedArguments: (productId: Int, hasLiked: Bool)?
    var hasLikedWithHasLikedReceivedInvocations: [(productId: Int, hasLiked: Bool)] = []
    var hasLikedWithHasLikedClosure: ((Int, Bool) -> Void)?

    func hasLiked(with productId: Int, hasLiked: Bool) {
        hasLikedWithHasLikedCallsCount += 1
        hasLikedWithHasLikedReceivedArguments = (productId: productId, hasLiked: hasLiked)
        hasLikedWithHasLikedReceivedInvocations.append((productId: productId, hasLiked: hasLiked))
        hasLikedWithHasLikedClosure?(productId, hasLiked)
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
    var likedProductWithHasLikeClosure: ((Int, Bool) -> Void)?

    func likedProduct(with productId: Int, hasLike: Bool) {
        likedProductWithHasLikeCallsCount += 1
        likedProductWithHasLikeReceivedArguments = (productId: productId, hasLike: hasLike)
        likedProductWithHasLikeReceivedInvocations.append((productId: productId, hasLike: hasLike))
        likedProductWithHasLikeClosure?(productId, hasLike)
    }

}
class ProductsViewNavigatorMock: ProductsViewNavigator {




    //MARK: - showDetails

    var showDetailsForCallsCount = 0
    var showDetailsForCalled: Bool {
        return showDetailsForCallsCount > 0
    }
    var showDetailsForReceivedProductId: (Int)?
    var showDetailsForReceivedInvocations: [(Int)] = []
    var showDetailsForClosure: ((Int) -> Void)?

    func showDetails(for productId: Int) {
        showDetailsForCallsCount += 1
        showDetailsForReceivedProductId = productId
        showDetailsForReceivedInvocations.append(productId)
        showDetailsForClosure?(productId)
    }

}
