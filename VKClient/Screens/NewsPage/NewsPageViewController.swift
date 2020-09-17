//
//  NewsPageViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 28.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit

class NewsPageViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    var newsIndex = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        
        for index in workingNewsList {
            if !newsIndex.contains(String(index.newsDescription.first!)){
                newsIndex.append(String(index.newsDescription.first!))
            }
        }
    }
}

extension NewsPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var newsRow = [NewsList]()
        for news in workingNewsList {
            if newsIndex[section].contains(news.newsDescription.first!) {
                newsRow.append(news)
            }
        }
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell", for: indexPath) as! NewsListCell
        
        
        return cell
    }
    
}
