//
//  GalleryAlbumImagesModel.swift
//  SpiderGroupTestTask
//
//  Created by Марина Айбулатова on 23.07.2021.
//

import Foundation

struct GalleryAlbumImagesModel: Codable {
    let data: [GalleryAlbumImages]
}

struct GalleryAlbumImages: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case link
        case images
        case isAlbum = "is_album"
        case type
    }
    
    let id: String
    let title: String?
    let description: String?
    let isAlbum: Bool
    let link: String?
    let type: ContentType?
    let images: [ImageModel]?
}

enum ContentType: String, Codable {
    case gif = "image/gif"
    case png = "image/png"
    case jpeg = "image/jpeg"
    case video = "video/mp4"
}

struct ImageModel: Codable {
    let id: String
    let title: String?
    let description: String?
    let link: String?
    let type: ContentType?
}

struct GalleryAlbumCommentsModel: Codable {
    let data: [Comment]
}
struct Comment: Codable {
    let id: Int
    let comment: String
}

