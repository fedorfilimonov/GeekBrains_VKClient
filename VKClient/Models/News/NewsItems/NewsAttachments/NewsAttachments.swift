//
//  NewsAttachments.swift
//  VKClient
//
//  Created by Федор Филимонов on 07.10.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import RealmSwift

class NewsAttachments: Object, Decodable {
    @objc dynamic var type: String = ""
    @objc dynamic var photo: NewsAttachmentsPhoto?
    @objc dynamic var link: NewsAttachmentsLink?
}
