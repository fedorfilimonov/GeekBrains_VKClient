//
//  NewsAttachmentsLink.swift
//  VKClient
//
//  Created by Федор Филимонов on 07.10.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import RealmSwift

class NewsAttachmentsLink: Object, Decodable {
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var caption: String? = nil
    @objc dynamic var photo: NewsAttachmentsPhoto?
}
