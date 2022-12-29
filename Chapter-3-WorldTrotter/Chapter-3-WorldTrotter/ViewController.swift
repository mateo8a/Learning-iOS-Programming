//
//  ViewController.swift
//  Chapter-3-WorldTrotter
//
//  Created by Mateo Ochoa on 2022-12-12.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var farenheitTextField: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        farenheitTextField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

