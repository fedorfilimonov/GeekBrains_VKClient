//
//  FriendRealm.swift
//  VKClient
//
//  Created by Федор Филимонов on 20.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import RealmSwift

class UserFriendCodable: Codable {
    let response: UserFriendResponse
}

class UserFriendResponse: Codable {
    let count: Int
    let items: [UserFriendItem]
}

class UserFriendItem: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = "firstName"
    @objc dynamic var lastName: String = "lastName"
    @objc dynamic var isClosed: Bool = true
    @objc dynamic var canAccessClosed: Bool = true
    @objc dynamic var photo_100: String = ""
    @objc dynamic var online: Int = 0
    @objc dynamic var trackCode: String = ""

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

