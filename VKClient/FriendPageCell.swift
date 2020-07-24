//
//  FriendPageCell.swift
//  VKClient
//
//  Created by Федор Филимонов on 14.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import UIKit

class FriendPageCell: UICollectionViewCell {
    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var photoLikes: PhotoLikesControl!
    
    var friendIndex: Int = 0
    var photoCounter: Int = 0
    
    func setUpLikeControl() {
        photoLikes.indexLike = friendIndex
        photoLikes.photoCount = photoCounter
        photoLikes.setUpView()
    }
}

