//
//  ItemStore.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-01-30.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
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
            sectionItems = itemsOverFifty(false)
        } else {
            sectionItems = itemsOverFifty(true)
        }
        
        let movedItem = sectionItems[row]
        let removeIndex = allItems.firstIndex(of: movedItem)!
        let inFrontOfItem = sectionItems[toIndex.row]
        let insertIndex = allItems.firstIndex(of: inFrontOfItem)!
        allItems.remove(at: removeIndex)
        allItems.insert(movedItem, at: insertIndex)
//        print(allItems.map {"\($0.name): \($0.valueInDollars)"})
    }
    
    func itemsOverFifty(_ show: Bool) -> [Item] {
        let itemsOverFifty = allItems.filter { item in
            if show {
                return item.valueInDollars > 50
            } else {
                return item.valueInDollars <= 50
            }
        }
        
        return itemsOverFifty
    }
    
    func itemAt(_ indexPath: IndexPath) -> Item {
        let section = indexPath.section
        let row = indexPath.row
        let item: Item
        if section == 0 {
            item = itemsOverFifty(false)[row]
        } else {
            item = itemsOverFifty(true)[row]
        }
        return item
    }
}
