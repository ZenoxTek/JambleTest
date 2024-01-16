//
//  LikeUseCase.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 16/01/2024.
//

import Foundation
import Combine

// MARK: - LikeUseCaseType

protocol LikeUseCaseType: AutoMockable {
    
    func getLikePublisher() -> AnyPublisher<(Int, Bool), Never>
    
    func publishData(with id: Int, action: Bool)
}

// MARK: - LikeUseCase

final class LikeUseCase: LikeUseCaseType {

    // MARK: Combine variable
    
    private let liked = PassthroughSubject<(Int, Bool), Never>()
    
    // MARK: Methods
    
    func getLikePublisher() -> AnyPublisher<(Int, Bool), Never> {
        liked.eraseToAnyPublisher()
    }
    
    func publishData(with id: Int, action: Bool) {
        liked.send((id, action))
    }
}


