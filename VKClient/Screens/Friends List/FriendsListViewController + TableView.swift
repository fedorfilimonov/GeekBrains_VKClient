//
//  FriendsListViewController + TableView.swift
//  VKClient
//
//  Created by Федор Филимонов on 29.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit
import RealmSwift

extension FriendsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListCell
        
        // Link to blank photo in case if friend`s photo is unavailable
        let photoUnavailableUrl = "https://www.rit.edu/nsfadvance/sites/rit.edu.nsfadvance/files/default_images/photo-unavailable.png"
        
        if let url = URL( string: self.filteredUsers?[indexPath.row].photo_100 ?? photoUnavailableUrl)
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
    
    // Segue with details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { tableView.deselectRow(at: indexPath, animated: true)
            
        let detailToSend = filteredUsers?[indexPath.row]
        
        performSegue(withIdentifier: FriendPageViewController.storyboardIdentifier, sender: detailToSend)
    }
}

