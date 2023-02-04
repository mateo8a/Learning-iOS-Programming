//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-01-30.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    
    // DataSource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return max(1, itemStore.itemsOverFifty(false).count)
        case 1:
            return max(1, itemStore.itemsOverFifty(true).count)
        default:
            return 0
        }
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var contentConf = cell.defaultContentConfiguration()
        if let item = itemStore.itemAt(indexPath) {
            
            if item.isFavorite {
                contentConf.image = UIImage(systemName: "star.fill")
                contentConf.imageProperties.tintColor = .systemYellow
            }
            contentConf.text = item.name
            contentConf.secondaryText = "$\(item.valueInDollars)"
            cell.contentConfiguration = contentConf
        } else {
            contentConf.text = "No items"
            cell.contentConfiguration = contentConf
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.itemAt(indexPath)!
            if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                let updates: () -> Void = {
                    self.itemStore.deleteItem(item)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
                tableView.performBatchUpdates(updates)
            } else {
                itemStore.deleteItem(item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    // Delegate methods
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let handler: (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void = { action, sourceView, completionHandler in
            let item = self.itemStore.itemAt(indexPath)
            item?.isFavorite.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite", handler: handler)
        favoriteAction.image = UIImage(systemName: "star.fill")
        favoriteAction.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    // Normal methods
    
    @IBAction func addNewItem(_ sender: UIButton) {
        let newItem = itemStore.createItem()
        let row: Int
        let section: Int
        let onlyItem: Bool
        if newItem.valueInDollars <= 50 {
            let items = itemStore.itemsOverFifty(false)
            row = items.firstIndex(of: newItem)!
            section = 0
            onlyItem = items.count == 1
        } else {
            let items = itemStore.itemsOverFifty(true)
            row = items.firstIndex(of: newItem)!
            section = 1
            onlyItem = items.count == 1
        }
        let indexPath = IndexPath(row: row, section: section)
        
        if onlyItem {
            let updates: () -> Void = {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            tableView.performBatchUpdates(updates)
        } else {
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
