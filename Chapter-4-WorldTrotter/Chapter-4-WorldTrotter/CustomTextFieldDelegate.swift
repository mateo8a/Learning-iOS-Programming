//
//  CustomTextDelegate.swift
//  Chapter-3-WorldTrotter
//
//  Created by Mateo Ochoa on 2022-12-29.
//

import Foundation
import UIKit

class CustomTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        let decimalSeparatorCS = CharacterSet(charactersIn: decimalSeparator)
        let allowedCharacters = decimalCharacters.union(decimalSeparatorCS)
        let characterSet = CharacterSet(charactersIn: string)
        
        let allowedCharactersCondition = allowedCharacters.isSuperset(of: characterSet)
        let oneDecimalSeparatorCondition = {
            var containsDecimalSeparator: Bool = false
            if let text = textField.text {
                containsDecimalSeparator = text.contains(decimalSeparator)
            }
            return !(containsDecimalSeparator && string.contains(decimalSeparator))
        }()
        return allowedCharactersCondition && oneDecimalSeparatorCondition
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Updates to the UI must always be from the main thread: https://stackoverflow.com/questions/61959052/uitextfield-starting-cursor-position-is-wrong/61960379#61960379
        DispatchQueue.main.async {
            let endPosition = textField.endOfDocument
            let range = textField.textRange(from: endPosition, to: endPosition)
            textField.selectedTextRange = range
        }
    }
}
