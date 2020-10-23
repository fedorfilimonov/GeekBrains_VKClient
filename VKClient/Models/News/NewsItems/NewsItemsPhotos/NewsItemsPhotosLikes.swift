//
//  NewsItemsPhotosLikes.swift
//  VKClient
//
//  Created by Федор Филимонов on 07.10.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import RealmSwift

class NewsItemsPhotosLikes: Object, Decodable {
    @objc dynamic var count: Int = 0
}
