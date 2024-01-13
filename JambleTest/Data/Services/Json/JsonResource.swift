//
//  JsonResouce.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

// MARK: - JsonResource

/// A generic class representing a JSON resource for decoding.
class JsonResource<T: Decodable> {
    
    // MARK: Properties
    
    /// The file name for the JSON resource.
    let file: String
    
    // MARK: Initialization
    
    /// Initializes a `JsonResource` with the specified file name.
    /// - Parameter file: The name of the JSON file.
    init(file: String) {
        self.file = file
    }
}
