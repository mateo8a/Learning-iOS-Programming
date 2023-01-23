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
    var uiLabel1: UILabel!
    var uiLabel2: UILabel!
    var uiLabel3: UILabel!
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
        farenheitTextField.keyboardType = .decimalPad
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
        celsiusLabel.textColor = .systemBlue
        let titleFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
        celsiusLabel.font = UIFont(descriptor: titleFontDescriptor, size: 70)
        celsiusLabel.numberOfLines = 0
        celsiusLabel.textAlignment = .center
        view.addSubview(celsiusLabel)
    }
    
    func setUpTextLabels() {
        uiLabel1 = UILabel()
        uiLabel2 = UILabel()
        uiLabel3 = UILabel()
        let farenheitString = NSLocalizedString("degrees Farenheit", comment: "the label for farenheit degrees")
        let isReallyString = NSLocalizedString("is really", comment: "the label for is really")
        let celsiusString = NSLocalizedString("degrees Celsius", comment: "the label for celsius degrees")
        uiLabel1.text = farenheitString
        uiLabel2.text = isReallyString
        uiLabel3.text = celsiusString
        uiLabel1.textColor = .systemOrange
        uiLabel2.textColor = .systemPurple
        uiLabel3.textColor = .blue
        let smallLabelsFontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption1)
        uiLabel1.font = UIFont(descriptor: smallLabelsFontDescriptor, size: 35)
        uiLabel2.font = UIFont(descriptor: smallLabelsFontDescriptor, size: 35)
        uiLabel3.font = UIFont(descriptor: smallLabelsFontDescriptor, size: 35)
        uiLabel1.numberOfLines = 0
        uiLabel2.numberOfLines = 0
        uiLabel3.numberOfLines = 0
        uiLabel1.textAlignment = .center
        uiLabel2.textAlignment = .center
        uiLabel3.textAlignment = .center
        view.addSubview(uiLabel1)
        view.addSubview(uiLabel2)
        view.addSubview(uiLabel3)
    }
    
    func setUpStack() {
        let stackedSubviews: [UIView] = [farenheitTextField, uiLabel1, uiLabel2, celsiusLabel, uiLabel3]
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
        stack.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
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
        if let farenheitString = sender.text, let farenheit = Double(farenheitString) {
            let celsius: Double = (farenheit - 32) * 5 / 9
            celsiusLabel.text = "\(celsius)"
        } else {
            celsiusLabel.text = ""
        }
    }
    
    @objc func changeFarenheit(_ sender: UITextField) {
        if let farenheitString = sender.text, let newFValue = numberFormatter.number(from: farenheitString) {
            farenheitValue = Measurement<UnitTemperature>(value: Double(truncating: newFValue), unit: .fahrenheit)
        } else {
            farenheitValue = nil
        }
    }
    
    func changeCelsiusLabel() {
        if let newCelsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: newCelsiusValue.value))
        } else {
            let formattedEmptyCelsius = NSAttributedString(string: "°C", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue.withAlphaComponent(0.5)])
            celsiusLabel.attributedText = formattedEmptyCelsius
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
