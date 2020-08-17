//
//  User.swift
//  VKClient
//
//  Created by Федор Филимонов on 15.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//


//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct UserFriendCodable: Codable {
    let response: UserFriendResponse
}

struct UserFriendResponse: Codable {
    let count: Int
    let items: [UserFriendItem]
}

struct UserFriendItem: Codable {
    let id: Int
    let firstName, lastName: String
    let isClosed, canAccessClosed: Bool
    let photo_100: String
    let online: Int
    let trackCode: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case photo_100 = "photo_100"
        case online
        case trackCode = "track_code"
    }
}
