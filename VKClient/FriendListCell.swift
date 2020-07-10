//
//  FriendListCell.swift
//  VKClient
//
//  Created by Федор Филимонов on 10.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import UIKit

class FriendListCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPic: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}