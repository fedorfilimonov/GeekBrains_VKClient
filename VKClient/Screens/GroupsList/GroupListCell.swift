//
//  GroupListCell.swift
//  VKClient
//
//  Created by Федор Филимонов on 10.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import UIKit

class GroupListCell: UITableViewCell {
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupPic: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

