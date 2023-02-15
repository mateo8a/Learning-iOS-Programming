//
//  ImageStore.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-02-15.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString,UIImage>()
    let fileManager = FileManager.default
    var documentDirectory: URL {
        let documentDirectories = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        let url = imageURL(forKey: key)
        if let data = image.jpegData(compressionQuality: 0.5) {
            createImagesFolderIfNeeded()
            do {
                try data.write(to: url)
            } catch {
                print("Error writing the image to disk: \(error)")
            }
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        if let loadedImage = cache.object(forKey: key as NSString) {
            return loadedImage
        }
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path()) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
    func imageURL(forKey key: String) -> URL {
        return documentDirectory.appending(path: "images/\(key)")
    }
    
    func createImagesFolderIfNeeded() {
        let url = documentDirectory.appending(path: "images/")
        if !fileManager.fileExists(atPath: url.path()) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: false)
            } catch {
                print("Could not create folder at \(url): \(error)")
            }
        }
    }
}
