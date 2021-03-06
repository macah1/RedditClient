//
//  ListingViewModel.swift
//  RedditClient
//
//  Created by Maca on 01/04/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//

import Foundation

protocol ListingViewModelDelegate: class {
    func didLoadedData()
    func didEndLoadOperation()
}

class ListingViewModel {
    weak var delegate: ListingViewModelDelegate?
    var posts: [Post]!
    var nextId: String?
    var hasMorePages = false
    var isRefreshing = false
    
    private let pageSize = 20
    private let redditAPI: RedditAPI!
    
    init() {
        self.redditAPI = RedditAPI()
        self.posts = []
    }
    
    func loadData() {
        if posts.count == 0 {
            nextId = nil
            hasMorePages = false
        }
        
        redditAPI.topPosts(limit: pageSize, after: nextId) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .failure(_):
                // TODO: failure case
                print("Failed fetching posts")
            case .success(let topPosts):
                if topPosts.posts.isEmpty {
                    strongSelf.hasMorePages = false
                } else {
                    if strongSelf.isRefreshing {
                        strongSelf.posts?.removeAll()
                        strongSelf.isRefreshing = false
                    }
                    strongSelf.posts?.append(contentsOf: topPosts.posts)
                    if let nextId = topPosts.nextId {
                        strongSelf.nextId = nextId
                        strongSelf.hasMorePages = true
                    }
                }
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadedData()
                }
            }
            DispatchQueue.main.async {
                strongSelf.delegate?.didEndLoadOperation()
            }
        }
    }
    
    func resetNextId() {
        nextId = nil
    }
    
    func setToRefresh() {
        isRefreshing = true
        nextId = nil
    }
    
    func setPostStatus(at index: Int, status: PostStatus) {
        if index < posts.count {
            posts[index].setStatus(status: status)
        }
    }
    
    func getDetailViewModel(withPostIndex index: Int) -> DetailViewModel? {
        if index < posts.count {
            let post = posts[index]
            let detailViewModel = DetailViewModel(withPost: post)
            return detailViewModel
        }
        return nil
    }
    
    func removePost(atIndex index: Int) {
        if index < posts.count {
            posts.remove(at: index)
        }
    }
    
    func reset() {
        self.posts.removeAll()
        resetNextId()
    }
}
