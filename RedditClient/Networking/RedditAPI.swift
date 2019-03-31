//
//  RedditAPI.swift
//  RedditClient
//
//  Created by Maca on 31/03/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import Foundation

import Foundation

protocol RedditAPIProtocol {
    func topPosts(limit: Int?, after: String?, completion: @escaping (_ result: Result<TopPosts>) -> Void)
}

class RedditAPI: RedditAPIProtocol {

    let kAPIUrl = "https://www.reddit.com/top.json"

    func topPosts(limit: Int?, after: String?, completion: @escaping (_ result: Result<TopPosts>) -> Void) {
        var urlString = kAPIUrl
        var urlComponents = URLComponents(string: kAPIUrl)
        urlComponents?.queryItems = []
        if limit != nil {
            let queryItemLimit = URLQueryItem(name: "limit", value: "\(limit!)")
            urlComponents?.queryItems?.append(queryItemLimit)
        }
        if after != nil {
            let queryItemAfter = URLQueryItem(name: "after", value: after!)
            urlComponents?.queryItems?.append(queryItemAfter)
        }
        if let url = urlComponents?.url {
            NetworkClient.get(url: url) { result in
                completion(result)
            }
        }
        
    }

}
