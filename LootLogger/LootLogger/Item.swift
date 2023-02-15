//
//  Item.swift
//  LootLogger
//
//  Created by Mateo Ochoa on 2023-01-30.
//

import UIKit

class Item: Equatable, Codable {
    
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    var isFavorite: Bool = false
    let itemKey: String
    
    init(name: String, serialNumber: String?, valueInDollars: Int, dateCreated: Date = Date()) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = dateCreated
        itemKey = UUID().uuidString
    }
    
    convenience init(_ item: Item?, random: Bool) {
        if let item = item {
            self.init(name: item.name, serialNumber: item.serialNumber, valueInDollars: item.valueInDollars, dateCreated: item.dateCreated)
        } else {
            self.init(random: random)
        }
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Macsfds fsfsfsds dfsfsfsdfs dfsdfs dfsdfsf"]
            let randomAdjective = adjectives.randomElement()!
            let randomNoun = nouns.randomElement()!
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int.random(in: 0..<100)
            let randomSerialNumber =
            UUID().uuidString.components(separatedBy: "-").first!
            self.init(name: randomName,
                      serialNumber: randomSerialNumber,
                      valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
        && lhs.serialNumber == rhs.serialNumber
        && lhs.valueInDollars == rhs.valueInDollars
        && lhs.dateCreated == rhs.dateCreated
    }
}
