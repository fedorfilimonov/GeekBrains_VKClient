//
//  FriendListViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 10.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.


import UIKit

class FriendsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var friendsListCatalogue = [
        FriendsListItem(friendName: "User_Name_1", friendPic: UIImage(named: "profilePhoto_1")!),
        FriendsListItem(friendName: "User_Name_2", friendPic: UIImage(named: "profilePhoto_2")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension FriendsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsListCatalogue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell") as? FriendListCell else { fatalError() }
        
        cell.userName.text = friendsListCatalogue[indexPath.row].friendName
        cell.userPic.avatarImage.image = friendsListCatalogue[indexPath.row].friendPic
        
        print("Cell created for row: \(indexPath.row), \(friendsListCatalogue[indexPath.row])")
        
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        
//        if segue.identifier == "FriendListActionSegue",
//            let cell = sender as? FriendListCell,
//            let destination = segue.destination as? FriendPageViewController {
//            destination.image = cell.userPic.avatarImage.image!
//        }
//    }
}
