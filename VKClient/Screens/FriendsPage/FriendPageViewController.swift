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
    
    static let storyboardIdentifier = "FriendListActionSegue"
    
    var friend = UserFriendItem()

    var photosList = [FriendPhotosItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        
        let friendID = String (friend.id)
        NetworkService.shared.getUserPhotosList(token: Session.shared.token, friendID: friendID) { [weak self] result in
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
    }
}

extension FriendPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPageCell", for: indexPath) as! FriendPageCell
        
        if let url = URL( string: photosList[indexPath.row].sizes.last?.url ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf: url)
                {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        
                        cell.userPic.image = image
                    }
                }
            }
        }
        return cell
    }
}
