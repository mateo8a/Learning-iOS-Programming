//
//  PhotoCollectionDelegate.swift
//  Photorama
//
//  Created by Mateo Ochoa on 2023-03-22.
//

import UIKit

class PhotoCollectionDelegate: NSObject, UICollectionViewDelegate {
    var store: PhotoStore!
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photoDataSource = collectionView.dataSource as! PhotoDataSource
        let photo = photoDataSource.photos[indexPath.row]
        
        store.fetchImage(for: photo) { result in
            guard let photoIndex = photoDataSource.photos.firstIndex(of: photo), case let .success(image) = result else {
                return
            }
            
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            if let cell = collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(displaying: image)
            }
        }
    }
}
