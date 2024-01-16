//
//  JsonServiceTest.swift
//  JambleTestTests
//
//  Created by Benjamin Duhieu on 16/01/2024.
//

import XCTest
import Combine
@testable import JambleTest

final class JsonServiceTest: XCTestCase {

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        return URLSession(configuration: config)
    }()
    private lazy var jsonService = JsonService(session: session)
    private lazy var productJsonData: Data = {
        let url = Bundle.main.url(forResource: "products", withExtension: "json")
        guard let resourceUrl = url, let data = try? Data(contentsOf: resourceUrl) else {
            XCTFail("Failed to create data object from string!")
            return Data()
        }
        return data
    }()
    private var cancellables: [AnyCancellable] = []

    override class func setUp() {
        URLProtocol.registerClass(URLProtocolMock.self)
    }

    func test_loadFinishedSuccessfully() {
        // Given
        var result: Result<[ProductDTO], Error>?
        let expectation = self.expectation(description: "networkServiceExpectation")
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: Constants.baseUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, self.productJsonData)
        }

        // When
        jsonService.load(JsonResource<[ProductDTO]>(file: Constants.jsonFile))
            .map({ products -> Result<[ProductDTO], Error> in Result.success(products)})
            .catch({ error -> AnyPublisher<Result<[ProductDTO], Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)
        
        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .success(let products) = result else {
            XCTFail()
            return
        }
        XCTAssertEqual(products.count, 15)
    }
    
    func test_loadFailedWithJsonParsingError() {
        // Given
        var result: Result<[ProductDTO], Error>?
        let expectation = self.expectation(description: "jsonServiceExpectation")

        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: Constants.baseUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When
        jsonService.load(JsonResource<[ProductDTO]>(file: Constants.jsonFile))
            .map({ products -> Result<[ProductDTO], Error> in Result.success(products)})
            .catch({ error -> AnyPublisher<Result<[ProductDTO], Error>, Never> in .just(.failure(error)) })
            .sink(receiveValue: { value in
                result = value
                expectation.fulfill()
            }).store(in: &cancellables)
        
        // Then
        self.waitForExpectations(timeout: 1.0, handler: nil)
        guard case .failure(let error) = result, error is DecodingError else {
            XCTFail()
            return
        }
    }
}
