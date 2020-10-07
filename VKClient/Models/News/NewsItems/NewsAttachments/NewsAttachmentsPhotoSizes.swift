//
//  NewsAttachmentsPhotoSizes.swift
//  VKClient
//
//  Created by Федор Филимонов on 07.10.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import RealmSwift

class NewsAttachmentsPhotoSizes: Object, Decodable {
    @objc dynamic var height: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var width: Int = 0
}
