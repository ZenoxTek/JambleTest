//
//  Publisher+Ext.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

import Foundation
import Combine

// MARK: - Publisher Extensions

extension Publisher {

    /**
     The `flatMapLatest` operator behaves much like the standard FlatMap operator, except that whenever
     a new item is emitted by the source Publisher, it will unsubscribe to and stop mirroring the Publisher
     that was generated from the previously-emitted item, and begin only mirroring the current one.
    */
    func flatMapLatest<T: Publisher>(_ transform: @escaping (Self.Output) -> T) -> Publishers.SwitchToLatest<T, Publishers.Map<Self, T>> where T.Failure == Self.Failure {
        map(transform).switchToLatest()
    }
}

extension Publisher {

    /// Creates an empty publisher.
    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }

    /// Creates a publisher that emits a specified output.
    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }

    /// Creates a publisher that immediately terminates with the specified error.
    static func fail(_ error: Failure) -> AnyPublisher<Output, Failure> {
        return Fail(error: error).eraseToAnyPublisher()
    }
}
