//
//  DetailViewModel.swift
//  RedditClient
//
//  Created by Maca on 01/04/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import Foundation

class DetailViewModel {

    // MARK: - Properties
    var author: String?
    var thumbImageUrl: String?
    var title: String?
    var url: String?
    
    // MARK: - Init
    init(withPost post: Post) {
        self.author = post.author
        self.thumbImageUrl = post.thumbnail
        self.title = post.title
        self.url = post.url
    }
}
