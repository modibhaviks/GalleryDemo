//
//  PhotosModel.swift
//  GalleryDemo
//
//  Created by Bhavik Modi on 04/01/22.
//

import Foundation

struct Photos: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

typealias PhotosModel = [Photos]
