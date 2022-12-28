//
//  ViewController.swift
//  Chapter-3-WorldTrotter
//
//  Created by Mateo Ochoa on 2022-12-12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var celsiusLabel: UILabel!
    
    @IBAction func convertFtoC(_ sender: UITextField) {
        celsiusLabel.text = sender.text
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor].reversed()
        gradientLayer.locations = [0.1, 0.2, 0.3, 0.4, 1]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

