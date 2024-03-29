//
//  ViewController.swift
//  Mandala
//
//  Created by Mateo Ochoa on 2023-02-20.
//

import UIKit

class MoodSelectionViewController: UIViewController {

    @IBOutlet var moodSelector: ImageSelector!
    @IBOutlet var addMoodButton: UIButton!
    
    var moodsConfigurable: MoodsConfigurable!
    
    var moods = [Mood]() {
        didSet {
            currentMood = moods.first
            moodSelector.highlightColors = moods.map { $0.color }
            moodSelector.images = moods.map { $0.image }
        }
    }
    
    var currentMood: Mood? {
        didSet {
            guard let currentMood = currentMood else {
                addMoodButton.setTitle(nil, for: .normal)
                addMoodButton.backgroundColor = nil
                return
            }
            addMoodButton.setTitle("I'm \(currentMood.name)", for: .normal)
            addMoodButton.backgroundColor = currentMood.color
        }
    }
    
    @IBAction func addMoodTapped(_ sender: UIButton) {
        guard let currentMood = currentMood else {
            return
        }
        let newMoodEntry = MoodEntry(mood: currentMood, timestamp: Date())
        moodsConfigurable.add(newMoodEntry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue being called")
        switch segue.identifier {
        case "embedContainerViewController":
            guard let moodsConfigurable = segue.destination as? MoodsConfigurable else {
                preconditionFailure("View controller expected to conform to MoodsConfigurable")
            }
            self.moodsConfigurable = moodsConfigurable
            segue.destination.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    @IBAction private func moodSelectionChanged(_ sender: ImageSelector) {
        let selectedIndex = sender.selectedIndex
        
        let selectionAnimator = UIViewPropertyAnimator(
            duration: 0.5,
            curve: .easeInOut,
            animations: {
                self.currentMood = self.moods[selectedIndex]
            }
        )
        selectionAnimator.startAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moods = [.happy, .sad, .angry, .goofy, .crying, .confused, .sleepy, .meh]
        addMoodButton.layer.cornerRadius = addMoodButton.bounds.height / 2
    }


}

