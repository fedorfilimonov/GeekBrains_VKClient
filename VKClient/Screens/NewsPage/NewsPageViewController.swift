//
//  NewsPageViewController.swift
//  VKClient
//
//  Created by Федор Филимонов on 28.07.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import UIKit
import RealmSwift

class NewsPageViewController: UIViewController {
    
    @IBOutlet weak var newsTableView: UITableView! {
        didSet {
            newsTableView.dataSource = self
        }
    }
    
    // Managers
    private var networkService = NetworkService.shared
    private var realmManager = RealmManager.shared

    // Receive news
    private var newsFromRealm: Results<NewsResponse>? {
        let newsFromRealm: Results<NewsResponse>? = realmManager?.getObjects()
        return newsFromRealm
    }

    //MARK: - ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPostNewsFromNetwork()
    }
}

extension NewsPageViewController {
    func loadPostNewsFromNetwork(completion: (() -> Void)? = nil) {
        networkService.loadNews(token: Session.shared.token, userID: Session.shared.userId, typeOfNews: .post) { [weak self] result in
            switch result {
            case let .success(postNews):
                try? self?.realmManager?.add(objects: [postNews])
                completion?()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func dateTranslator(timeToTranslate: Int) -> String {
        var date: Date?
        date = Date(timeIntervalSince1970: Double(timeToTranslate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date!)
        return localDate
    }
}

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
