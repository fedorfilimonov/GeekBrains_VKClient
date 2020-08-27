//
//  FriendListViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 10.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendSearch: UISearchBar!
    
    private var networkService = NetworkService.shared
    private var realmManager = RealmManager.shared
    
    private var friendsList: Results<UserFriendItem>? {
        let users: Results<UserFriendItem>? = realmManager?.getObjects()
        return users?.sorted(byKeyPath: "id", ascending: true)
    }
    
    private var filteredUsers: Results<UserFriendItem>? {
        guard !searchText.isEmpty else { return friendsList }
        return friendsList?.filter(NSPredicate(format: "name CONTAINS[cd] %@", searchText))
    }
    
    private var searchText: String {
        friendSearch.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
//        friendSearch.delegate = self
        tableView.register (UINib (nibName: "NameLetterView" , bundle: nil ), forCellReuseIdentifier: "NameLetterCell" )
        self.tableView.tableFooterView = UIView()
        
        loadData()
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkService.getUserFriendsList(token: Session.shared.token, userID: Session.shared.userId) { [weak self] result in
            
            switch result {
            case let .success(userFriendsList):

                DispatchQueue.main.async {
                    let userFriendsListArray = userFriendsList.response.items
                    try? self?.realmManager?.add(objects: userFriendsListArray)
                    self?.tableView.reloadData()
                    completion?()
                }
                
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension FriendsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell

        if let url = URL( string: self.friendsList?[indexPath.row].photo_100 ?? "")
        {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf: url)
                {
                    DispatchQueue.main.async {
                        let lastName = self.filteredUsers?[indexPath.row].last_name ?? " "
                        let firstName = self.filteredUsers?[indexPath.row].first_name ?? " "
                        let image = UIImage(data: data)
                        
                        cell.userName.text = lastName + " " + firstName
                        cell.userPic.avatarImage.image = image
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

//extension FriendsListViewController: UISearchBarDelegate{
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        var friendsListForSearch = friendsList
//
//        friendsListForSearch = searchText.isEmpty ? friendsList : friendsList.filter { (item: UserFriendItem) -> Bool in
//            return item.last_name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
//
//        friendsIndex = [String]()
//
//        for index in friendsListForSearch {
//            if !friendsIndex.contains(String(index.last_name.first!)){
//                friendsIndex.append(String(index.last_name.first!))
//            }
//        }
//
//        friendsListForSearch.sort {
//            $0.last_name < $1.last_name
//        }
//
//        friendsIndex.sort()
//        self.tableView.reloadData()
//    }
//}



//import UIKit
//
//class FriendsListViewController: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var friendSearch: UISearchBar!
//
//    var friendsIndex = [String]()
//    var friendsList = [UserFriendItem]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.dataSource = self
//        friendSearch.delegate = self
//        tableView.register (UINib (nibName: "NameLetterView" , bundle: nil ), forCellReuseIdentifier: "NameLetterCell" )
//        self.tableView.tableFooterView = UIView()
//
//        NetworkService.shared.getUserFriendsList(token: Session.shared.token, userID: Session.shared.userId) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case let .success(userFriendsList):
//                self.friendsList = userFriendsList.response.items
//
//                self.friendsList.sort {
//                    $0.last_name < $1.last_name
//                }
//
//                for index in self.friendsList {
//                    if !self.friendsIndex.contains(String(index.last_name.first!)){
//                        self.friendsIndex.append(String(index.last_name.first!))
//                    }
//                }
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
////        print(friendsList)
//    }
//}
//
//extension FriendsListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var friendRow = [UserFriendItem]()
//        for friend in friendsList {
//            if friendsIndex[section].contains(friend.last_name.first!) {
//                friendRow.append(friend)
//            }
//        }
//        return friendRow.count
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return friendsIndex.count
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return friendsIndex[section]
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
//
//        var friendRow = [UserFriendItem]()
//        for friend in friendsList {
//            if friendsIndex[indexPath.section].contains(friend.last_name.first!) {
//                friendRow.append(friend)
//            }
//        }
//
//        if let url = URL( string: friendRow[indexPath.row].photo_100)
//        {
//            DispatchQueue.global().async {
//                if let data = try? Data( contentsOf: url)
//                {
//                    DispatchQueue.main.async {
//                        cell.userName.text = friendRow[indexPath.row].last_name + " " + friendRow[indexPath.row].first_name
//                        cell.userPic.avatarImage.image = UIImage(data: data)
//                    }
//                }
//            }
//        }
//
//        return cell
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "FriendListActionSegue" {
//            let indexPath = self.tableView.indexPathForSelectedRow
//            let destination = segue.destination as? FriendPageViewController
//
//            var indexRowCounter = 0
//
//            for index in 0..<indexPath!.section {
//                indexRowCounter += self.tableView.numberOfRows(inSection: index)
//            }
//
//            indexRowCounter += indexPath!.row
//
//            destination!.selectedFriend = indexRowCounter
//        }
//    }
//}
//
//extension FriendsListViewController: UISearchBarDelegate{
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        var friendsListForSearch = friendsList
//
//        friendsListForSearch = searchText.isEmpty ? friendsList : friendsList.filter { (item: UserFriendItem) -> Bool in
//            return item.last_name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
//
//        friendsIndex = [String]()
//
//        for index in friendsListForSearch {
//            if !friendsIndex.contains(String(index.last_name.first!)){
//                friendsIndex.append(String(index.last_name.first!))
//            }
//        }
//
//        friendsListForSearch.sort {
//            $0.last_name < $1.last_name
//        }
//
//        friendsIndex.sort()
//        self.tableView.reloadData()
//    }
//}
