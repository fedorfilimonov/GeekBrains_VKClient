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
    
    // UI
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // Managers
    private var networkService = NetworkService.shared
    private var realmManager = RealmManager.shared
    
    // Realm notifications
    private var filteredUsersNotificationToken: NotificationToken?
    private var firstUserNotificationToken: NotificationToken?
    
    // Received Friends List
    private var friendsList: Results<UserFriendItem>? {
        let users: Results<UserFriendItem>? = realmManager?.getObjects()
        return users?.sorted(byKeyPath: "last_name", ascending: true)
    }
    
    // Filtration of Friend List
    var filteredUsers: Results<UserFriendItem>? {
        guard !searchText.isEmpty else { return friendsList }
        return friendsList?.filter(NSPredicate(format: "last_name CONTAINS[cd] %@", searchText))
    }
    
    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateSectionInTable(nibname: "NameLetterView", forCellReuseIdentifier: "NameLetterView")
        loadData()
        addRealmNotifications()
    }
    
    deinit {
        filteredUsersNotificationToken?.invalidate()
    }
}

extension FriendsListViewController {
    
    private func initiateSectionInTable (nibname: String, forCellReuseIdentifier: String) {
        tableView.register (UINib (nibName: nibname , bundle: nil ), forCellReuseIdentifier: forCellReuseIdentifier )
        self.tableView.tableFooterView = UIView()
    }
    
    private func loadData(completion: (() -> Void)? = nil) {
        networkService.getUserFriendsList(token: Session.shared.token, userID: Session.shared.userId) { [weak self] result in
            
            switch result {
            case let .success(userFriendsList):
                
                DispatchQueue.main.async {
                    let userFriendsListArray = userFriendsList.response.items
                    try? self?.realmManager?.add(objects: userFriendsListArray)
                    completion?()
                }
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func showAlert(title: String? = nil,
                           message: String? = nil,
                           handler: ((UIAlertAction) -> ())? = nil,
                           completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
    
    // MARK: - Segue to Friend Page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? FriendPageViewController {
            if let detailToSend = sender {
                destinationVC.friend = detailToSend as! UserFriendItem
            }
        }
    }
}

// MARK: - Search
extension FriendsListViewController: UISearchBarDelegate {
    
    private var searchText: String {
        searchBar.text ?? ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}

extension FriendsListViewController {
    
    func addRealmNotifications() {
        filteredUsersNotificationToken = filteredUsers?.observe { [weak self] change in
            switch change {
            case .initial:
                #if DEBUG
                print("Initialized")
                #endif
                
            case let .update(results, deletions: deletions, insertions: insertions, modifications: modifications):
                #if DEBUG
                print("""
                New count: \(results.count)
                Deletions: \(deletions)
                Insertions: \(insertions)
                Modifications: \(modifications)
            """)
                #endif
                
                self?.tableView.beginUpdates()
                
                self?.tableView.deleteRows(at: deletions.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                self?.tableView.insertRows(at: insertions.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                self?.tableView.reloadRows(at: modifications.map { IndexPath(item: $0, section: 0) }, with: .automatic)
                
                self?.tableView.endUpdates()
                
            case let .error(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        
        firstUserNotificationToken = filteredUsers?.first?.observe { [weak self] change in
            switch change {
            case let .change(object, properties):
                #if DEBUG
                let whatChanged = properties.reduce("") { res, new in
                    "\(res)\n\(new.name) -> \(new.newValue ?? "nil")"
                }
                let user = object as? UserFriendItem
                print("Changed properties for user \(user?.first_name ?? "unknowned")\n\(whatChanged)")
                #endif
                
            case .deleted:
                #if DEBUG
                print("The first user was deleted")
                #endif
                
            case let .error(error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
