//
//  Session.swift
//  VKClient
//
//  Created by Федор Филимонов on 07.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation

class Session {
    
    var token: String?
    var userID: String?
    
    public static let shared = Session()
    private init(){}
    
}
