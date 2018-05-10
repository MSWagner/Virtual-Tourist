//
//  PhotoSearchResult.swift
//  Virtual-Tourist
//
//  Created by Matthias Wagner on 09.05.18.
//  Copyright © 2018 Matthias Wagner. All rights reserved.
//

import Foundation

struct FlickrPhotoSearchResult: Codable {
    var photos: FlickrPhotos
}

struct FlickrPhotos: Codable {
    var photo: [FlickrPhotoData]

    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
}

struct FlickrPhotoData: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
}
