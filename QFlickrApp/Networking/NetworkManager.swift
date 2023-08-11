//
//  NetworkManager.swift
//  QFlickrApp
//
//  Created by Adam Essam on 10/08/2023.
//

import Foundation


protocol NetworkProtocol {
    func searchflickrPhotos(searchTerm: String, page: Int) async throws -> Photos
}

final class NetworkManager: NetworkProtocol {
    
    private let apiKey = "6af377dc54798281790fc638f6e4da5e"
    private let baseUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
    
    
    func searchflickrPhotos(searchTerm: String, page: Int) async throws -> Photos {
        guard let url = URL(string: "\(baseUrl)&api_key=\(apiKey)&format=json&nojsoncallback=1&text=\(searchTerm)&page=\(page)") else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        do {
            data.jsonToString()
            let decoder = JSONDecoder()
            return try decoder.decode(ImageDataModel.self, from: data).photos

        } catch {
            throw APIError.invalidData
        }
    }
}
