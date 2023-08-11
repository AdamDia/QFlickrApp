//
//  FlickrViewModelTests.swift
//  QFlickrAppTests
//
//  Created by Adam Essam on 11/08/2023.
//


import XCTest
@testable import QFlickrApp
import SwiftUI

@MainActor
class FlickrViewModelTests: XCTestCase {
    
    var mockViewModel: FlickrViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockViewModel = FlickrViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        mockViewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func test_searchPhotosFailure() async {
        // Given
        mockNetworkManager.shouldFail = true
        
        // When
        await mockViewModel.searchPhotos(searchTerm: "cat")
        
        // Then
        XCTAssertEqual(mockViewModel.alertItem?.title, Text("Server Error"))
        XCTAssertEqual(mockViewModel.alertItem?.message, Text("The data received from the server was invalid. Please contact support"))
    }
    
    func test_searchPhotosSuccess() async {
        // Given
        let expectation = XCTestExpectation(description: "Results Fetched Successfully")
        // When
        await mockViewModel.searchPhotos(searchTerm: "dogs")
        
        // Then
        do {
            try await Task.sleep(nanoseconds: 5_000_000_000)
        } catch {
            XCTFail("Failed to sleep: \(error)")
        }
        
        XCTAssertEqual(self.mockViewModel.flickrImages.count, 2)
        
        expectation.fulfill()
        await XCTWaiter().fulfillment(of: [expectation], timeout: 10)
    }
    
    func test_getPhotoURL() {
        // Given
        let photo = mockPhotosData.first!
        let comparedURLStr = "https://farm1.static.flickr.com/65535/53106485484_mvMGKE7VkF5UHaz0I.jpg"
        
        // When
        let result = mockViewModel.getPhotoURL(photoObj: photo)
        
        // Then
        XCTAssertEqual(result, URL(string: comparedURLStr))
    }
    
    func test_fetchMorePhotosSuccess() async {
        
        // Given
        let expectation = XCTestExpectation(description: "Results Fetched Successfully")
        let searchTerm = "cats"
        
        //when
        await mockViewModel.fetchMorePhotos(searchTerm: searchTerm)
        
        // Then
        do {
            try await Task.sleep(nanoseconds: 5_000_000_000)
        } catch {
            XCTFail("Failed to sleep: \(error)")
        }
    
        XCTAssertEqual(mockViewModel.page, 2)
        XCTAssertEqual(mockViewModel.totalPages, 10)
        XCTAssertGreaterThan(mockViewModel.flickrImages.count, 1)
        
        expectation.fulfill()
        await XCTWaiter().fulfillment(of: [expectation], timeout: 10)
    }
}
