//
//  GroupsListViewController + TableView.swift
//  VKClient
//
//  Created by Федор Филимонов on 29.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit
import RealmSwift

extension GroupsListViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredGroups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as! GroupListCell
        
        if let url = URL( string: self.filteredGroups?[indexPath.row].photo100 ?? "")
        {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf: url)
                {
                    DispatchQueue.main.async {
                        cell.groupName.text = self.filteredGroups?[indexPath.row].name
                        cell.groupPic.image = UIImage(data: data)
                        
                    }
                }
            }
        }
        
        return cell
    }
}
