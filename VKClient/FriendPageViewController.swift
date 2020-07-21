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
    
    var profilePic1: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }
}

extension FriendPageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPageCell", for: indexPath) as! FriendPageCell
        
        cell.userPic.image = profilePic1
        return cell
    }
    
    
}
