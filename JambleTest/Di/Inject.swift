//
//  Inject.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

import Swinject

@propertyWrapper
public struct Inject<Value> {
    public private(set) var wrappedValue: Value
    
    public init() {
        self.init(name: nil, resolver: nil)
    }
    
    public init(name: String? = nil, resolver: Resolver? = nil) {
        guard let resolver = resolver ?? InjectSettings.resolver else {
            fatalError("Make sure InjectSettings.resolver is set!")
        }
        
        guard let value = resolver.resolve(Value.self, name: name) else {
            fatalError("Could not resolve non-optional \(Value.self)")
        }
        
        wrappedValue = value
    }
    
    public init<Wrapped>(name: String? = nil, resolver: Resolver? = nil) where Value == Optional<Wrapped> {
        guard let resolver = resolver ?? InjectSettings.resolver else {
            fatalError("Make sure InjectSettings.resolver is set!")
        }
        
        wrappedValue = resolver.resolve(Wrapped.self, name: name)
    }
}

extension Container: Resolver {
    
}
