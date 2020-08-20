//
//  Group.swift
//  VKClient
//
//  Created by Федор Филимонов on 15.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation

struct UserGroupsCodable: Codable {
    let response: UserGroupsResponse
}

struct UserGroupsResponse: Codable {
    let count: Int
    let items: [UserGroupsItem]
}

struct UserGroupsItem: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: String
    let isAdmin, isMember, isAdvertiser: Int
    let photo50, photo100, photo200: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

