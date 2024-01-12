//
//  JsonService.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine

final class JsonService: JsonServiceType {
    private let session: URLSession

    init(session: URLSession = URLSession(configuration: URLSessionConfiguration.ephemeral)) {
        self.session = session
    }

    @discardableResult
    func load<T>(_ resource: JsonResource<T>) -> AnyPublisher<T, Error> {
        guard let url = Bundle.main.url(forResource: resource.file, withExtension: "json") else {
            return .fail(JsonError.invalidRequest)
        }
        return session.dataTaskPublisher(for: url)
            .mapError{ _ in JsonError.invalidRequest }
            .print()
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                return .just(data)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
