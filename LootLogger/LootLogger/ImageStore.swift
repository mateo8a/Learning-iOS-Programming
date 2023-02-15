//
//  ImageStore.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-02-15.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString,UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
