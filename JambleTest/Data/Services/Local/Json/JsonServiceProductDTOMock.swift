//
//  JsonServiceProductDTOMock.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 16/01/2024.
//

import Foundation
import Combine

class JsonServiceTypeMock<U: Decodable>: JsonServiceType {
   
    
        
    //MARK: - load

    var loadCallsCount = 0
    var loadCalled: Bool {
        return loadCallsCount > 0
    }
    var loadReceivedResource: (JsonResource<U>)?
    var loadReceivedInvocations: [(JsonResource<U>)] = []
    var loadReturnValue: AnyPublisher<U, Error>!
    var loadClosure: ((JsonResource<U>) -> AnyPublisher<U, Error>)?

    @discardableResult
    func load<T>(_ resource: JsonResource<T>) -> AnyPublisher<T, Error> {
        loadCallsCount += 1
        loadReceivedResource = resource as! JsonResource<U>
        loadReceivedInvocations.append(resource as! JsonResource<U>)
        if let loadClosure = loadClosure {
            return loadClosure(resource as! JsonResource<U>) as! AnyPublisher<T, Error>
        } else {
            return loadReturnValue as! AnyPublisher<T, Error>
        }
    }
}
