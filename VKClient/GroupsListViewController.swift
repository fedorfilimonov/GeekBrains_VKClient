//
//  GroupListViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 10.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit

class GroupsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var groupsListCatalogue = [
        GroupsListItem(groupName: "Group_Name_1", groupPic: UIImage(named: "profilePhoto_2")!),
        GroupsListItem(groupName: "Group_Name_2", groupPic: UIImage(named: "profilePhoto_2")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension GroupsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsListCatalogue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell") as? GroupListCell else { fatalError() }
        
        cell.groupName.text = groupsListCatalogue[indexPath.row].groupName
        cell.groupPic.image = groupsListCatalogue[indexPath.row].groupPic
        
        print("Cell created for row: \(indexPath.row), \(groupsListCatalogue[indexPath.row])")
        
        return cell
    }
}
