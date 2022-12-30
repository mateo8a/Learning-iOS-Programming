//
//  ViewController.swift
//  Chapter-3-WorldTrotter
//
//  Created by Mateo Ochoa on 2022-12-12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var farenheitTextField: UITextField!
    let textFieldDelegate = CustomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        farenheitTextField.delegate = textFieldDelegate
        
//        From https://stackoverflow.com/a/55983883
        let tap = UITapGestureRecognizer(target: farenheitTextField, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @IBAction func convertFtoC(_ sender: UITextField) {
        let farenheit = sender.text!
        let celsius: Int
        if !farenheit.isEmpty {
            let f = Int(farenheit)!
            celsius = (f - 32) * 5 / 9
            celsiusLabel.text = "\(celsius)"
        } else {
            celsiusLabel.text = ""
        }
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
