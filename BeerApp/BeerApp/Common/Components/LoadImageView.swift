//
//  UIImageView+Cache.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/8/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

let imageNSCache = NSCache<AnyObject, AnyObject>()

class LoadImageView: UIImageView {
    
    var imageURL: URL?
    
    func loadImageWithLink(_ link: String) {
        guard let url = URL(string: link) else {
            return
        }

        imageURL = url
        if let imageFromCache = imageNSCache.object(forKey: url.lastPathComponent as AnyObject) as? UIImage {
            self.image = imageFromCache
        } else if let image = ImageCache.sharedInstance.getImage(key: url.lastPathComponent) {
            self.image = image
            imageNSCache.setObject(image, forKey: url.lastPathComponent as AnyObject)
        } else {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async(execute: {
                    
                    if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                        if self.imageURL == url {
                            self.image = imageToCache
                        }
                        ImageCache.sharedInstance.saveImageInCache(image: imageToCache, key: url.lastPathComponent)
                        imageNSCache.setObject(imageToCache, forKey: url.lastPathComponent as AnyObject)
                    }
                })
            }).resume()
        }
    }
}

