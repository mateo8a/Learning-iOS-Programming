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
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex { return }
        
        let movedItem = allItems[fromIndex]
        allItems.remove(at: fromIndex)
        allItems.insert(movedItem, at: toIndex)
        allItems[toIndex] = movedItem
    }
}
