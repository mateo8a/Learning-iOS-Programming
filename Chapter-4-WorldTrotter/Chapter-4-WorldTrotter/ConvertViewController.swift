//
//  ViewController.swift
//  Chapter-3-WorldTrotter
//
//  Created by Mateo Ochoa on 2022-12-12.
//

import UIKit

class ConvertViewController: UIViewController {
    var farenheitTextField: UITextField!
    var celsiusLabel: UILabel!
    let textFieldDelegate = CustomTextFieldDelegate()
    
    override func loadView() {
        view = UIView()
        
        farenheitTextField = UITextField()
        farenheitTextField.text = "32"
        farenheitTextField.keyboardType = .numberPad
        farenheitTextField.textColor = .orange
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
        farenheitTextField.font = UIFont(descriptor: fontDescriptor, size: 70)
        view.addSubview(farenheitTextField)
        
        
        
        celsiusLabel = UILabel()
        celsiusLabel.text = "0"
        celsiusLabel.textColor = .systemGreen
        celsiusLabel.font = UIFont(descriptor: fontDescriptor, size: 70)
        view.addSubview(celsiusLabel)

        let margins = view.layoutMarginsGuide
        farenheitTextField.translatesAutoresizingMaskIntoConstraints = false
        farenheitTextField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        farenheitTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        celsiusLabel.translatesAutoresizingMaskIntoConstraints = false
        celsiusLabel.topAnchor.constraint(equalTo: farenheitTextField.bottomAnchor, constant: 20).isActive = true
        celsiusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        farenheitTextField.delegate = textFieldDelegate

//        From https://stackoverflow.com/a/55983883
        let tap = UITapGestureRecognizer(target: farenheitTextField, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    func convertFtoC(_ sender: UITextField) {
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
