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
    var newsFromRealm: Results<NewsResponse>? {
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

