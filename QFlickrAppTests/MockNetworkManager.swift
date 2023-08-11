//
//  MockNetworkManager.swift
//  QFlickrAppTests
//
//  Created by Adam Essam on 11/08/2023.
//

import Foundation
@testable import QFlickrApp

final class MockNetworkManager: NetworkProtocol, JsonLoader {
   
    var mockMatches = [Photo]()
    var shouldFail = false
    
    func searchFlickrPhotos(searchTerm: String, page: Int) async throws -> Photos {
        let result = try await loadJSON(filename: "MockSearchResults", type: Photos.self)
        if !shouldFail {
            return result
        } else {
            throw APIError.invalidData
        }
    }
}
