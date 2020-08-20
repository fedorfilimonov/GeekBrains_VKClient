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
    
    var groupsIndex = [String]()
    var groupsList = [UserGroupsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.register (UINib (nibName: "NameLetterView" , bundle: nil ), forCellReuseIdentifier: "NameLetterCell" )
        self.tableView.tableFooterView = UIView()
        
        NetworkService.shared.getUserGroupsList(token: Session.shared.token, userID: Session.shared.userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(userGroupsList):
                self.groupsList = userGroupsList.response.items
                
                self.groupsList.sort {
                    $0.name < $1.name
                }
                
                for index in self.groupsList {
                    if !self.groupsIndex.contains(String(index.name.first!)){
                        self.groupsIndex.append(String(index.name.first!))
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

extension GroupsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var groupRow = [UserGroupsItem]()
        for group in groupsList {
            if groupsIndex[section].contains(group.name.first!) {
                groupRow.append(group)
            }
        }
        return groupRow.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupsIndex.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupsIndex[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as! GroupListCell
        
        var groupRow = [UserGroupsItem]()
        for group in groupsList {
            if groupsIndex[indexPath.section].contains(group.name.first!) {
                groupRow.append(group)
            }
        }
        
        if let url = URL( string: groupRow[indexPath.row].photo100)
        {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf: url)
                {
                    DispatchQueue.main.async {
                        cell.groupName.text = groupRow[indexPath.row].name
                        cell.groupPic.image = UIImage(data: data)
                        
                    }
                }
            }
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            groupsList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
