//
//  ItemStore.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-01-30.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    var onlyFavoriteItems: [Item] {
        allItems.filter { item in
            item.isFavorite
        }
    }

    
    init() {
        for _ in 0..<5 {
            createItem()
        }
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
        if section == 0, itemsForSection(0).count > 0 {
            if onlyFavorites {
                let items = itemsForSection(0).filter { $0.isFavorite }
                if items.count > 0 {
                    item = items[row]
                }

            } else {
                item = itemsForSection(0)[row]
            }
        } else if section == 1, itemsForSection(1).count > 0 {
            if onlyFavorites {
                let items = itemsForSection(1).filter { $0.isFavorite }
                if items.count > 0 {
                    item = items[row]
                }
            } else {
                item = itemsForSection(1)[row]
            }
        }
        return item
    }
    
}
