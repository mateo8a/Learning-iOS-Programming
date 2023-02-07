//
//  ItemStore.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-01-30.
//

import UIKit
import Foundation

class ItemStore {
    var allItems = [Item]()
    var onlyFavoriteItems: [Item] {
        allItems.filter { item in
            item.isFavorite
        }
    }
    let itemArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appending(path: "items.plist")
    }()

    
    init() {
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let decoder = PropertyListDecoder()
            let items = try decoder.decode([Item].self, from: data)
            allItems = items
        } catch {
            print("Error reading in saved items: \(error)")
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        // Add option to insert item at the top of the list
        //        allItems.insert(newItem, at: 0)
        return newItem
    }
    
    func deleteItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: IndexPath, to toIndex: IndexPath) {
        if fromIndex == toIndex { return }
        if fromIndex.section != toIndex.section { return }
        
        let row = fromIndex.row
        let sectionItems: [Item]
        if fromIndex.section == 0 {
            sectionItems = itemsForSection(0)
        } else {
            sectionItems = itemsForSection(1)
        }
        
        let movedItem = sectionItems[row]
        let removeIndex = allItems.firstIndex(of: movedItem)!
        let inFrontOfItem = sectionItems[toIndex.row]
        let insertIndex = allItems.firstIndex(of: inFrontOfItem)!
        allItems.remove(at: removeIndex)
        allItems.insert(movedItem, at: insertIndex)
        //        print(allItems.map {"\($0.name): \($0.valueInDollars)"})
    }
    
    @objc func saveChanges() -> Bool {
        print("Saving items at \(itemArchiveURL)")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allItems)
            try data.write(to: itemArchiveURL, options: .atomic)
            return true
        } catch let saveError {
            print("Saving failed with error: \(saveError)")
            return false
        }
    }
}

// This extension is for methods that are to be used specifically by the implementation of the table in ItemsViewController
extension ItemStore {
    func itemsForSection(_ section: Int) -> [Item] {
        let itemsOverFifty = allItems.filter { item in
            if section == 1 {
                return item.valueInDollars > 50
            } else if section == 0 {
                return item.valueInDollars <= 50
            } else {
                return false
            }
        }
        
        return itemsOverFifty
    }
    
    func itemAt(_ indexPath: IndexPath, onlyFavorites: Bool) -> Item? {
        let section = indexPath.section
        let row = indexPath.row
        var item: Item? = nil
        if !itemsForSection(section).isEmpty {
            item = getItemAtRow(row, section: section, onlyFavorites: onlyFavorites)
        }
        return item
    }
    
    private func getItemAtRow(_ row: Int, section: Int, onlyFavorites: Bool) -> Item? {
        var item: Item? = nil
        if onlyFavorites {
            let items = itemsForSection(section).filter { $0.isFavorite }
            if items.count > 0 {
                item = items[row]
            }
        } else {
            item = itemsForSection(section)[row]
        }
        return item
    }
    
}
