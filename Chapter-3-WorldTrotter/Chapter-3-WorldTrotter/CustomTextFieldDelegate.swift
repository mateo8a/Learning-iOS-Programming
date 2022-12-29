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
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
