//
//  NewsItemsPhotosComments.swift
//  VKClient
//
//  Created by Федор Филимонов on 07.10.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import RealmSwift

class NewsItemsPhotosComments: Object, Decodable {
    @objc dynamic var count: Int = 0
}
