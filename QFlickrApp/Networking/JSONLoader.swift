//
//  JSONLoader.swift
//  QFlickrApp
//
//  Created by Adam Essam on 10/08/2023.
//

import Foundation

protocol JsonLoader: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(filename: String, type: T.Type) async throws -> T
}

extension JsonLoader {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJSON<T: Decodable>(filename: String, type: T.Type) async throws -> T {
        guard let path = bundle.url(forResource: filename, withExtension: ".json") else {
            throw NSError(domain: "Failed to load JSON file", code: 0, userInfo: nil)
        }
        
        let data = try Data(contentsOf: path)
        let decodedObject = try JSONDecoder().decode(T.self, from: data)
        return decodedObject
    }
}
