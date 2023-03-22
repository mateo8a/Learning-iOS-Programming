//
//  ViewController.swift
//  Photorama
//
//  Created by Mateo Ochoa on 2023-03-07.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchInterestingPhotos { result in
            switch result {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                self.updateImageView(for: photos.first!)
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) { imageResult in
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
}

