//
//  JsonResouce.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 12/01/2024.
//

class JsonResource<T: Decodable> {
    
    let file: String
    
    init(file: String) {
        self.file = file
    }
}
