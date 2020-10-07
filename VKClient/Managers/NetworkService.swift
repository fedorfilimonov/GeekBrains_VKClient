//
//  NetworkManager.swift
//  VKClient
//
//  Created by Федор Филимонов on 12.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class NetworkService {
    
    // Manager
    static let shared = NetworkService()
    init() {}
    
    // Data for API address
    private let scheme = "https"
    private let host = "api.vk.com"
    private let version = "5.122"
    
    static let sessionAF: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: configuration)
        return session
    }()
    
    // MARK: - Load friends list
    
    func getUserFriendsList (token: String, userID: String, completion: ((Swift.Result<UserFriendCodable, Error>) -> Void)? = nil) {
        
        // Adding to Global Queue
        DispatchQueue.global(qos: .userInitiated).async {
            let configuration = URLSessionConfiguration.default
            //        let session =  URLSession(configuration: configuration)
            let _ =  URLSession(configuration: configuration)
            
            var urlConstructor = URLComponents()
            urlConstructor.scheme = self.scheme
            urlConstructor.host = self.host
            urlConstructor.path = "/method/friends.get"
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: token),
                URLQueryItem(name: "user_id", value: userID),
                URLQueryItem(name: "order", value: "name"),
                URLQueryItem(name: "fields", value: "photo_100"),
                URLQueryItem(name: "v", value: self.version),
            ]
            
            guard let url = urlConstructor.url else { return }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else { return }
                
                do {
                    let userFriendsList  = try JSONDecoder().decode(UserFriendCodable.self, from: data)
                    completion?(.success(userFriendsList))
                    
                } catch {
                    print(error.localizedDescription)
                    completion?(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: - Load groups list
    
    func getUserGroupsList (token: String, userID: String, completion: ((Swift.Result<UserGroupsCodable, Error>) -> Void)? = nil) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let configuration = URLSessionConfiguration.default
            //        let session =  URLSession(configuration: configuration)
            let _ =  URLSession(configuration: configuration)
            
            var urlConstructor = URLComponents()
            urlConstructor.scheme = self.scheme
            urlConstructor.host = self.host
            urlConstructor.path = "/method/groups.get"
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: token),
                URLQueryItem(name: "user_id", value: userID),
                URLQueryItem(name: "extended", value: "1"),
                URLQueryItem(name: "count", value: "20"),
                URLQueryItem(name: "v", value: self.version),
            ]
            
            guard let url = urlConstructor.url else { return }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else { return }
                
                do {
                    let userGroupsList  = try JSONDecoder().decode(UserGroupsCodable.self, from: data)
                    completion?(.success(userGroupsList))
                    
                } catch {
                    print(error.localizedDescription)
                    completion?(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: - Groups search
    func getRequestedGroupsList (token: String) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = scheme
        urlConstructor.host = host
        urlConstructor.path = "/method/groups.search"
        urlConstructor.queryItems = [
            URLQueryItem(name: "q", value: "MDK"), // add link to search
        ]
        
        guard let url = urlConstructor.url else { return }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) {
                    print(json)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Load user photos
    
    func getUserPhotosList (token: String, friendID: String, completion: ((Swift.Result<FriendPhotosCodable, Error>) -> Void)? = nil) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let configuration = URLSessionConfiguration.default
            //        let session =  URLSession(configuration: configuration)
            let _ =  URLSession(configuration: configuration)
            
            var urlConstructor = URLComponents()
            urlConstructor.scheme = self.scheme
            urlConstructor.host = self.host
            urlConstructor.path = "/method/photos.get"
            urlConstructor.queryItems = [
                URLQueryItem(name: "access_token", value: token),
                URLQueryItem(name: "owner_id", value: friendID),
                URLQueryItem(name: "album_id", value: "profile"),
                URLQueryItem(name: "photo_sizes", value: "0"),
                URLQueryItem(name: "count", value: "50"),
                URLQueryItem(name: "v", value: self.version),
            ]
            
            guard let url = urlConstructor.url else { return }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else { return }
                
                do {
                    let userPhotosList  = try JSONDecoder().decode(FriendPhotosCodable.self, from: data)
                    completion?(.success(userPhotosList))
                    print(userPhotosList)
                    
                } catch {
                    print(error.localizedDescription)
                    completion?(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    // MARK: - Load news
    
    enum typeOfNews: String {
        case post = "post"
        case photo = "photo,wall_photo"
    }
    
    func loadNews(token: String, userID: String, typeOfNews: typeOfNews, completion: ((Result<NewsResponse, Error>) -> Void)? = nil) {
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token": token,
            "user_id": userID,
            "filters": typeOfNews,
            "source_ids": "groups",
            "count": 5,
            "v": "5.124"
        ]
        
        NetworkService.sessionAF.request("https://api.vk.com" + path, method: .get, parameters: params).responseData(queue: .global(qos: .utility)) { response in
            guard let data = response.value else { return }
            
            var newsItems = List<NewsItems>()
            var newsProfiles = List<NewsProfiles>()
            var newsGroups = List<NewsGroups>()
            
            let parsedNewsElementsDispatchGroup = DispatchGroup()
            
            DispatchQueue.global().async(group: parsedNewsElementsDispatchGroup) {
                newsItems = try! JSONDecoder().decode(News.self, from: data).response?.items ?? List<NewsItems>()
            }
            DispatchQueue.global().async(group: parsedNewsElementsDispatchGroup) {
                newsProfiles = try! JSONDecoder().decode(News.self, from: data).response?.profiles ??  List<NewsProfiles>()
            }
            DispatchQueue.global().async(group: parsedNewsElementsDispatchGroup) {
                newsGroups = try! JSONDecoder().decode(News.self, from: data).response?.groups ?? List<NewsGroups>()
            }
            
            parsedNewsElementsDispatchGroup.notify(queue: DispatchQueue.main) {
                let news = NewsResponse(items: newsItems, profiles: newsProfiles, groups: newsGroups, newsResponseNewOffset: "", nextFrom: "")
                completion?(.success(news))
            }
        }
    }
}
