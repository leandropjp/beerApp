//
//  ImageCache.swift
//  BeerApp
//
//  Created by Leandro Paiva Andrade on 5/8/18.
//  Copyright © 2018 Leandro. All rights reserved.
//

import UIKit

class ImageCache: NSObject {
    
    static let sharedInstance = ImageCache()
    private let fileManager = FileManager.default
    
    private func getDocumentsDirectory() -> URL {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL
    }
    
    func saveImageInCache(image: UIImage, key: String) {
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(key)")
            do {
                try data.write(to: filename, options: .atomic)
            } catch {
                print("couldn't write image")
            }
        }
    }
    
    func getImage(key: String) -> UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent("\(key)")
        if fileManager.fileExists(atPath: filename.path) {
            return UIImage(contentsOfFile: filename.path)
        }
        return nil
    }
}
