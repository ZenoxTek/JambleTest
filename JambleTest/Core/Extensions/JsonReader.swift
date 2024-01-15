//
//  JsonReader.swift
//  JambleTest
//
//  Created by Benjamin Duhieu on 16/01/2024.
//

import Foundation

// MARK: - Use in UnitTests

func loadModelFromJSONFile<T: Decodable>(fileName: String, modelType: T.Type) -> [T]? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        print("File \(fileName) not found in bundle.")
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let models = try decoder.decode([T].self, from: data)
        return models
    } catch {
        print("Error decoding JSON file: \(error.localizedDescription)")
        return nil
    }
}
