//
//  Resolver.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 14/01/2024.
//

public protocol Resolver {
    func resolve<T>(_ type: T.Type, name: String?) -> T?
}
