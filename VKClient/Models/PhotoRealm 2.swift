//
//  PhotoRealm.swift
//  VKClient
//
//  Created by Федор Филимонов on 15.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import RealmSwift

class FriendPhotosCodable: Codable {
    let response: FriendPhotosResponse
}

class FriendPhotosResponse: Codable {
    let count: Int
    let items: [FriendPhotosItem]
}

class FriendPhotosItem: Object, Codable {
    var albumID = RealmOptional<Int>()
    var date = RealmOptional<Int>()
    var id = RealmOptional<Int>()
    var ownerID = RealmOptional<Int>()
    var hasTags = RealmOptional<Bool>()
    var postID = RealmOptional<Int>()
    var sizes = List<FriendPhotosSize>()
    @objc dynamic var text: String? = nil

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case hasTags = "has_tags"
        case postID = "post_id"
        case sizes, text
    }
}

class FriendPhotosSize: Object, Codable {
    var height = RealmOptional<Int>()
    @objc dynamic var url: String? = nil
    @objc dynamic var type: String? = nil
    var width = RealmOptional<Int>()
}
