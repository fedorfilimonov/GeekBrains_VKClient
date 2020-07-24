//
//  FriendsRecord.swift
//  VKClient
//
//  Created by Федор Филимонов on 21.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit

struct FriendsRecord: Equatable {
    var friendName: String
    var friendPhoto: [FriendPhoto]
}

struct FriendPhoto: Equatable {
    var photoName: UIImage
    var isPhotoLiked: Bool
    var photoLikesNumber: Int
}

var friendsListCatalogue = [
    FriendsRecord(friendName: "Tim Cook", friendPhoto: [FriendPhoto(photoName: UIImage(named: "TC_1")!, isPhotoLiked: true, photoLikesNumber: 1), FriendPhoto(photoName: UIImage(named: "TC_2")!, isPhotoLiked: false, photoLikesNumber: 2) ]),
    FriendsRecord(friendName: "Craig Federighi", friendPhoto: [FriendPhoto(photoName: UIImage(named: "CF_1")!, isPhotoLiked: true, photoLikesNumber: 1), FriendPhoto(photoName: UIImage(named: "CF_2")!, isPhotoLiked: false, photoLikesNumber: 2), FriendPhoto(photoName: UIImage(named: "CF_3")!, isPhotoLiked: false, photoLikesNumber: 2) ]),
    FriendsRecord(friendName: "Eddy Cue", friendPhoto: [FriendPhoto(photoName: UIImage(named: "EC_1")!, isPhotoLiked: false, photoLikesNumber: 2), FriendPhoto(photoName: UIImage(named: "EC_2")!, isPhotoLiked: false, photoLikesNumber: 2) ]),
]

var workingFriendsListCatalogue = friendsListCatalogue
