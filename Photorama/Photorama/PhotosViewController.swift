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
        
        store.fetchInterestingPhotos()
    }
}

