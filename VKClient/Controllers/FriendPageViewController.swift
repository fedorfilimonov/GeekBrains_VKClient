//
//  FriendPageViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 14.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit

class FriendPageViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedFriend: Int = 0
    var photosList = [FriendPhotosItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        NetworkService.shared.getUserPhotosList(token: Session.shared.token, friendID: Session.shared.userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(userPhotosList):
                self.photosList = userPhotosList.response.items
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
//        print(photosList)
    }
}


extension FriendPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return workingFriendsListCatalogue[selectedFriend].friendPhoto.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPageCell", for: indexPath) as! FriendPageCell
        
//        cell.userPic.image = workingFriendsListCatalogue[selectedFriend].friendPhoto[indexPath.row].photoName
//        cell.photoCounter = indexPath.row
//        cell.friendIndex = selectedFriend
//        cell.setUpLikeControl()
        
        cell.userPic.image = workingFriendsListCatalogue[selectedFriend].friendPhoto[indexPath.row].photoName
        
        
        
        return cell
    }
}
