//
//  APIError.swift
//  QFlickrApp
//
//  Created by Adam Essam on 10/08/2023.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
