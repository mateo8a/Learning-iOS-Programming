//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-02-06.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
            navigationItem.backButtonTitle = item.name
        }
    }
    
    // View Controller methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: item.valueInDollars as NSNumber)
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        let oldItem = Item(item!, random: true)
        
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        if let value = valueField.text {
            item.valueInDollars = numberFormatter.number(from: value)!.intValue
        } else {
            item.valueInDollars = 0
        }
        
        let userInfo = ["oldItem" : oldItem, "modifiedItem" : item!]
        let notification = Notification(name: Notification.Name("modifiedItem"), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "dateChanger":
            let destination = segue.destination as! DateChangeController
            destination.item = item
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // Text Field delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    // Normal methods
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
       return formatter
    }()
}
