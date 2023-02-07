//
//  DateChangeController.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-02-06.
//

import UIKit

class DateChangeController: UIViewController {
    var item: Item!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.date = item.dateCreated
        descriptionLabel.text = "Creation date of item \(item.name)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        item.dateCreated = datePicker.date
    }
}
