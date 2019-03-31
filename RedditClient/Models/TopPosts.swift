//
//  TopPosts.swift
//  RedditClient
//
//  Created by Maca on 31/03/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import Foundation

struct TopPosts: Decodable {
    var posts: [Post]
    var nextId: String?
    
    private enum DataKeys: String, CodingKey {
        case data
    }
    
    private enum ChildrenKeys: String, CodingKey {
        case children
        case nextId = "after"
    }
    
    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: DataKeys.self)
        let childrenContainer = try dataContainer.nestedContainer(keyedBy: ChildrenKeys.self, forKey: .data)
        
        if let postData = try? childrenContainer.decodeIfPresent([Post].self, forKey: .children) {
            posts = postData!
        } else {
            posts = []
        }
        
        if let nextIdData = try? childrenContainer.decodeIfPresent(String.self, forKey: .nextId) {
            nextId = nextIdData
        }
    }
}
