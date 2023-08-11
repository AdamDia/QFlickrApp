//
//  ImageDataModel.swift
//  QFlickrApp
//
//  Created by Adam Essam on 09/08/2023.
//

import Foundation

struct ImageDataModel: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable, Identifiable, Equatable {
    let id: String
    let secret: String
    let title: String
    let farm: Int
    let server: String
}
