//
//  ViewController.swift
//  Photorama
//
//  Created by Mateo Ochoa on 2023-03-07.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        
        store.fetchInterestingPhotos { result in
            switch result {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadData()
        }
    }
    
}

