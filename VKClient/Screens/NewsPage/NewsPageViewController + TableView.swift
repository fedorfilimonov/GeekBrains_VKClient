//
//  NewsPageViewController + TableView.swift
//  VKClient
//
//  Created by Федор Филимонов on 09.10.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension NewsPageViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFromRealm?.first?.items.count ?? 0
    }
    
    //MARK: - Cell For Row At IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        configureCell(indexPath: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell") as? NewsListCell else { fatalError() }
        
        let news = newsFromRealm?.first?.items[indexPath.row]
        
//        cell.authorName.text =
        cell.datePosted.text = dateTranslator(timeToTranslate: news?.date ?? 0)
        cell.postText.text = news?.text ?? ""
        cell.likesNumber.text = String(news!.likes!.count)
        cell.viewsCountNumber.text = String(news!.views!.count)
        
        if news?.newsAttachments.first?.type == "link" {
            let newsPostPhoto = news?.newsAttachments[0].link?.photo?.sizes.first?.url ?? ""
            guard let url = URL(string: newsPostPhoto), let data = try? Data(contentsOf: url) else { return cell }
            cell.authorPhoto.image = UIImage(data: data) ?? UIImage(systemName: "tortoise.fill")
        }
        
        if news?.newsAttachments.first?.type == "photo" {
            let newsPostPhoto = news?.newsAttachments.first?.photo?.sizes.last?.url ?? ""
            guard let url = URL(string: newsPostPhoto), let data = try? Data(contentsOf: url) else { return cell }
            cell.authorPhoto.image = UIImage(data: data) ?? UIImage(systemName: "tortoise.fill")
        }
        
        return cell
        
    }
}
