//
//  NetworkManager.swift
//  VKClient
//
//  Created by Федор Филимонов on 12.08.2020.
//  Copyright © 2020 fedorfilimonov. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    init() {}
    
    private let version = "5.122"
    
    func showUserFriendsList (token: String, userID: String) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/friends.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "user_id", value: userID),
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "10"),
            URLQueryItem(name: "count", value: "3"),
            URLQueryItem(name: "v", value: version),
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
    
    func showUserGroupsList (token: String, userID: String) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "user_id", value: userID),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "name"),
            URLQueryItem(name: "count", value: "3"),
            URLQueryItem(name: "v", value: version),
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
    
    func showRequestedGroupsList (token: String) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
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
    
    func showUserPhotosList (token: String, userID: String)  {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/photos.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "user_id", value: userID),
            URLQueryItem(name: "owner_id", value: userID),
            URLQueryItem(name: "album_id", value: "wall"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "3"),
            URLQueryItem(name: "v", value: version),
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
}
