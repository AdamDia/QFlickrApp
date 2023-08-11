//
//  NetworkManagerTests.swift
//  QFlickrAppTests
//
//  Created by Adam Essam on 11/08/2023.
//

import XCTest
@testable import QFlickrApp

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!

    override func setUp() {
        super.setUp()
        networkManager = NetworkManager()
    }

    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }

    func testSearchFlickr() async throws {
        // Given
        let searchTerm = "dogs"

        // When
        let results = try await networkManager.searchFlickrPhotos(searchTerm: searchTerm, page: 1)

        // Then
        XCTAssertGreaterThan(results.photo.count, 0, "testSearchFlickr() should return at least one trailer")
    }
}
