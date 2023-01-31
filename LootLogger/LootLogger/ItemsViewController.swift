//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-01-30.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_: UITableView, titleForHeaderInSection: Int) -> String? {
        let sectionTitle: String?
        switch titleForHeaderInSection {
        case 0:
            sectionTitle = "Items below $50"
        case 1:
            sectionTitle = "Items above $50"
        default:
            sectionTitle = ""
        }
        return sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return itemStore.itemsOverFifty(false).count
        case 1:
            return itemStore.itemsOverFifty(true).count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let item: Item
        if indexPath.section == 0 {
            let items = itemStore.itemsOverFifty(false)
            item = items[indexPath.row]
        } else {
            let items = itemStore.itemsOverFifty(true)
            item = items[indexPath.row]
        }
        
        var contentConf = cell.defaultContentConfiguration()
        contentConf.text = item.name
        contentConf.secondaryText = "$\(item.valueInDollars)"
        cell.contentConfiguration = contentConf
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            itemStore.deleteItem(item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    @IBAction func addNewItem(_ sender: UIButton) {
        let newItem = itemStore.createItem()
        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 1)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .focused)
            setEditing(true, animated: true)
        }
    }
}
