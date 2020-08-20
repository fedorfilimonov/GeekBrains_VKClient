//
//  FriendListViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 10.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendSearch: UISearchBar!
    
    var friendsIndex = [String]()
    var friendsList = [UserFriendItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        friendSearch.delegate = self
        tableView.register (UINib (nibName: "NameLetterView" , bundle: nil ), forCellReuseIdentifier: "NameLetterCell" )
        self.tableView.tableFooterView = UIView()
        
        NetworkService.shared.getUserFriendsList(token: Session.shared.token, userID: Session.shared.userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(userFriendsList):
                self.friendsList = userFriendsList.response.items
                
                self.friendsList.sort {
                    $0.lastName < $1.lastName
                }
                
                for index in self.friendsList {
                    if !self.friendsIndex.contains(String(index.lastName.first!)){
                        self.friendsIndex.append(String(index.lastName.first!))
                    }
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension FriendsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var friendRow = [UserFriendItem]()
        for friend in friendsList {
            if friendsIndex[section].contains(friend.lastName.first!) {
                friendRow.append(friend)
            }
        }
        return friendRow.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return friendsIndex.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsIndex[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
        
        var friendRow = [UserFriendItem]()
        for friend in friendsList {
            if friendsIndex[indexPath.section].contains(friend.lastName.first!) {
                friendRow.append(friend)
            }
        }
        
        if let url = URL( string: friendRow[indexPath.row].photo_100)
        {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf: url)
                {
                    DispatchQueue.main.async {
                        cell.userName.text = friendRow[indexPath.row].firstName + " " + friendRow[indexPath.row].lastName
                        cell.userPic.avatarImage.image = UIImage(data: data)
                    }
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FriendListActionSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let destination = segue.destination as? FriendPageViewController
            
            var indexRowCounter = 0
            
            for index in 0..<indexPath!.section {
                indexRowCounter += self.tableView.numberOfRows(inSection: index)
            }
            
            indexRowCounter += indexPath!.row
            
            destination!.selectedFriend = indexRowCounter
        }
    }
}

extension FriendsListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var friendsListForSearch = friendsList
        
        friendsListForSearch = searchText.isEmpty ? friendsList : friendsList.filter { (item: UserFriendItem) -> Bool in
            return item.lastName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        friendsIndex = [String]()
        
        for index in friendsListForSearch {
            if !friendsIndex.contains(String(index.lastName.first!)){
                friendsIndex.append(String(index.lastName.first!))
            }
        }
        
        friendsListForSearch.sort {
            $0.lastName < $1.lastName
        }
        
        friendsIndex.sort()
        self.tableView.reloadData()
    }
}
