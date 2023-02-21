//
//  MoodListViewController.swift
//  Mandala
//
//  Created by Mateo Ochoa on 2023-02-21.
//

import UIKit

class MoodListViewController: UITableViewController {
    var moodEntries = [MoodEntry]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moodEntry = moodEntries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.image = moodEntry.mood.image
        var imageProperties = content.imageProperties
        imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.imageProperties = imageProperties
        content.text = "I was \(moodEntry.mood.name)"
        let dateString = DateFormatter.localizedString(from: moodEntry.timestamp, dateStyle: .medium, timeStyle: .short)
        content.secondaryText = "on \(dateString)"
        
        cell.contentConfiguration = content
        return cell
    }
}

extension MoodListViewController: MoodsConfigurable {
    func add(_ moodEntry: MoodEntry) {
        moodEntries.insert(moodEntry, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}
