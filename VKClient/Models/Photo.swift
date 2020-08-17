//
//  Photo.swift
//  VKClient
//
//  Created by Федор Филимонов on 15.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

//   let photo = try? newJSONDecoder().decode(Photo.self, from: jsonData)

import Foundation

struct Photo: Codable {
    let response: PhotoResponse
}

struct PhotoResponse: Codable {
    let count: Int
    let items: [PhotoItem]
}

struct PhotoItem: Codable {
    let albumID, date, id, ownerID: Int
    let hasTags: Bool
    let postID: Int
    let sizes: [PhotoSize]
    let text: String
    let likes: PhotoLikes
    let reposts, comments: PhotoComments
    let canComment: Int
    let tags: PhotoComments

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case postID = "post_id"
        case sizes, text, likes, reposts, comments
        case canComment = "can_comment"
        case tags
    }
}

struct PhotoComments: Codable {
    let count: Int
}

struct PhotoLikes: Codable {
    let userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

struct PhotoSize: Codable {
    let height: Int
    let url: String
    let type: String
    let width: Int
}
