//
//  NewsResponse.swift
//  VKClient
//
//  Created by Федор Филимонов on 07.10.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import RealmSwift

class NewsResponse: Object, Decodable {
    var items = List<NewsItems>()
    var profiles = List<NewsProfiles>()
    var groups = List<NewsGroups>()
    @objc dynamic var newsResponseNewOffset: String? = nil
    @objc dynamic var nextFrom: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case items
        case profiles
        case groups
        case newsResponseNewOffset = "new_offset"
        case nextFrom = "next_from"
    }
    
    convenience init(items: List<NewsItems>, profiles: List<NewsProfiles>, groups: List<NewsGroups>, newsResponseNewOffset: String, nextFrom: String) {
        self.init()
        self.items = items
        self.profiles = profiles
        self.groups = groups
        self.newsResponseNewOffset = newsResponseNewOffset
        self.nextFrom = nextFrom
    }
    
    override class func primaryKey() -> String? {
        return "nextFrom"
    }
}
