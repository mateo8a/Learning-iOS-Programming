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
    let delegate = PhotoCollectionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = delegate
        delegate.store = store
        
        updateDataSource()
        
        store.fetchInterestingPhotos { result in
            self.updateDataSource()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto":
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    private func updateDataSource() {
        store.fetchAllPhotos { photoResult in
            switch photoResult {
            case .success(let photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadData()
        }
    }
}

