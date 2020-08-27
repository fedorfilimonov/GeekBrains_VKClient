//
//  GroupRealm.swift
//  VKClient
//
//  Created by Федор Филимонов on 15.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import RealmSwift

class UserGroupsCodable: Codable {
    let response: UserGroupsResponse
}

class UserGroupsResponse: Codable {
    let count: Int
    let items: [UserGroupsItem]
}

class UserGroupsItem: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = "Group Name"
    @objc dynamic var screenName: String  = "Group Name"
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var isAdmin: Int = 0
    @objc dynamic var isMember: Int = 0
    @objc dynamic var isAdvertiser: Int = 0
    @objc dynamic var photo50: String = ""
    @objc dynamic var photo100: String = ""
    @objc dynamic var photo200: String = ""

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
