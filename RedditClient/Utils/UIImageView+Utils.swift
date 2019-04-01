//
//  UIImageView+Utils.swift
//  RedditClient
//
//  Created by Maca on 01/04/2019.
//  Copyright © 2019 Pablo Bernardi. All rights reserved.
//


import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func cacheImage(urlString: String){
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if data != nil {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                    self.image = imageToCache
                }
            }
            }.resume()
    }
}
