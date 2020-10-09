//
//  GroupListViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 10.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsListViewController: UIViewController {
    
    // UI
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    // Managers
    private var networkService = NetworkService.shared
    private var realmManager = RealmManager.shared
    
    // Realm notifications
    private var groupsNotificationToken: NotificationToken?
    private var firstGroupNotificationToken: NotificationToken?
    
    // Received Groups List
    private var groupsList: Results<UserGroupsItem>? {
        let users: Results<UserGroupsItem>? = realmManager?.getObjects()
        return users?.sorted(byKeyPath: "name", ascending: true)
    }
    
    // Filtration of Groups List
    var filteredGroups: Results<UserGroupsItem>? {
        guard !searchText.isEmpty else { return groupsList }
        return groupsList?.filter(NSPredicate(format: "name CONTAINS[cd] %@", searchText))
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        initiateRealmNotifications()
    }
    
    deinit {
        groupsNotificationToken?.invalidate()
    }
}

extension GroupsListViewController {
    
    // MARK: - Realm Notifications
    func initiateRealmNotifications() {
        groupsNotificationToken = groupsList?.observe { [weak self] change in
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
        
        firstGroupNotificationToken = groupsList?.first?.observe { [weak self] change in
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
    
    // MARK: Loading of Groups List
    private func loadData(completion: (() -> Void)? = nil) {
        NetworkService.shared.getUserGroupsList(token: Session.shared.token, userID: Session.shared.userId) { [weak self] result in
            
            switch result {
            case let .success(userGroupsList):
                
                DispatchQueue.main.async {
                    let userGroupsListArray = userGroupsList.response.items
                    try? self?.realmManager?.add(objects: userGroupsListArray)
                    completion?()
                }
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
    // MARK: - Alert Manager
    private func showAlert(title: String? = nil,
                           message: String? = nil,
                           handler: ((UIAlertAction) -> ())? = nil,
                           completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: completion)
    }
}

// MARK: - Search
extension GroupsListViewController: UISearchBarDelegate {
    private var searchText: String {
        searchBar.text ?? ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }
}
