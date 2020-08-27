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
    
    private let scheme = "https"
    private let host = "api.vk.com"
    private let version = "5.122"
    
    func getUserFriendsList (token: String, userID: String, completion: ((Swift.Result<UserFriendCodable, Error>) -> Void)? = nil) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = scheme
        urlConstructor.host = host
        urlConstructor.path = "/method/friends.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "user_id", value: userID),
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "photo_100"),
            URLQueryItem(name: "v", value: version),
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
    
    func getUserGroupsList (token: String, userID: String, completion: ((Swift.Result<UserGroupsCodable, Error>) -> Void)? = nil) {
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = scheme
        urlConstructor.host = host
        urlConstructor.path = "/method/groups.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "user_id", value: userID),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "v", value: version),
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
    
    func getUserPhotosList (token: String, friendID: String, completion: ((Swift.Result<FriendPhotosCodable, Error>) -> Void)? = nil) {
        
        let configuration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configuration)
        
        var urlConstructor = URLComponents()
        urlConstructor.scheme = scheme
        urlConstructor.host = host
        urlConstructor.path = "/method/photos.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "owner_id", value: friendID),
            URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "count", value: "3"),
            URLQueryItem(name: "v", value: version),
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
