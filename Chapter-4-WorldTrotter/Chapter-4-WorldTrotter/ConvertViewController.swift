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
    var textField1: UITextField!
    var textField2: UITextField!
    var textField3: UITextField!
    var stack: UIStackView!
    var farenheitValue: Measurement<UnitTemperature>? {
        didSet {
            changeCelsiusLabel()
        }
    }
    var celsiusValue: Measurement<UnitTemperature>? {
        if let farenheitValue = farenheitValue {
            return farenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    let textFieldDelegate = CustomTextFieldDelegate()
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    override func loadView() {
        view = UIView()
        
        setUpFarenheitTextField()
        setUpTextLabels()
        setUpCelsiusLabel()
        setUpStack()
    }
    
    func setUpFarenheitTextField() {
        farenheitTextField = UITextField()
        farenheitTextField.attributedPlaceholder = NSAttributedString(string: "°F", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemOrange.withAlphaComponent(0.5)])
        farenheitTextField.text = "32"
        farenheitTextField.keyboardType = .numberPad
        farenheitTextField.textColor = .systemOrange
        let titleFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
        farenheitTextField.font = UIFont(descriptor: titleFontDescriptor, size: 70)
        view.addSubview(farenheitTextField)
        // Two ways of doing the conversion:
//        farenheitTextField.addTarget(self, action: #selector(convertFtoC(_:)), for: .editingChanged)
        farenheitTextField.addTarget(self, action: #selector(changeFarenheit(_:)), for: .editingChanged)
    }
    
    func setUpCelsiusLabel() {
        celsiusLabel = UILabel()
        celsiusLabel.text = "0"
        celsiusLabel.textColor = .systemGreen
        let titleFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
        celsiusLabel.font = UIFont(descriptor: titleFontDescriptor, size: 70)
        view.addSubview(celsiusLabel)
    }
    
    func setUpTextLabels() {
        textField1 = UITextField()
        textField2 = UITextField()
        textField3 = UITextField()
        textField1.text = "degrees Farenheit"
        textField2.text = "is really"
        textField3.text = "degrees Celcius"
        textField1.textColor = .systemOrange
        textField2.textColor = .systemBlue
        textField3.textColor = .systemGreen
        let smallLabelsFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption1)
        textField1.font = UIFont(descriptor: smallLabelsFontDescriptor, size: 35)
        textField2.font = UIFont(descriptor: smallLabelsFontDescriptor, size: 35)
        textField3.font = UIFont(descriptor: smallLabelsFontDescriptor, size: 35)
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(textField3)
    }
    
    func setUpStack() {
        let stackedSubviews: [UIView] = [farenheitTextField, textField1, textField2, celsiusLabel, textField3]
        stack = UIStackView(arrangedSubviews: stackedSubviews)
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalCentering
        view.addSubview(stack)
        
        let margins = view.layoutMarginsGuide
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        farenheitTextField.delegate = textFieldDelegate

//        From https://stackoverflow.com/a/55983883
        let tap = UITapGestureRecognizer(target: farenheitTextField, action: #selector(UIView.endEditing(_:)))
        // Another way of doing the same as above:
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        farenheitTextField.resignFirstResponder()
    }

    @objc func convertFtoC(_ sender: UITextField) {
        if let farenheitString = sender.text, let farenheit = Int(farenheitString) {
            let celsius: Int = (farenheit - 32) * 5 / 9
            celsiusLabel.text = "\(celsius)"
        } else {
            celsiusLabel.text = ""
        }
    }
    
    @objc func changeFarenheit(_ sender: UITextField) {
        if let farenheitString = sender.text, let newFValue = Double(farenheitString) {
            farenheitValue = Measurement<UnitTemperature>(value: newFValue, unit: .fahrenheit)
        } else {
            farenheitValue = nil
        }
    }
    
    func changeCelsiusLabel() {
        if let newCelsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: newCelsiusValue.value))
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
