//
//  Post.swift
//  RedditClient
//
//  Created by Maca on 31/03/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import Foundation

struct Post: Decodable {
    var created: Date?
    var author: String?
    var title: String?
    var thumbnail: String?
    var numComments: Int?
    var url: String?
    
    private enum DataKeys: String, CodingKey {
        case data
    }
    
    private enum PostKeys: String, CodingKey {
        case created = "created_utc"
        case author
        case title
        case thumbnail
        case numComments = "num_comments"
        case url
    }
    
    init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: DataKeys.self)
        let postContainer = try dataContainer.nestedContainer(keyedBy: PostKeys.self, forKey: .data)
        
        if let createdData = try? postContainer.decodeIfPresent(Date.self, forKey: .created) {
            created = createdData
        }
        
        if let authorData = try? postContainer.decodeIfPresent(String.self, forKey: .author) {
            author = authorData
        }
        
        if let titleData = try? postContainer.decodeIfPresent(String.self, forKey: .title) {
            title = titleData
        }
        
        if let thumbnailData = try? postContainer.decodeIfPresent(String.self, forKey: .thumbnail) {
            thumbnail = thumbnailData
        }
        
        if let numCommentsData = try? postContainer.decodeIfPresent(Int.self, forKey: .numComments) {
            numComments = numCommentsData
        }
        
        if let urlData = try? postContainer.decodeIfPresent(String.self, forKey: .url) {
            url = urlData
        }
        
    }
}
