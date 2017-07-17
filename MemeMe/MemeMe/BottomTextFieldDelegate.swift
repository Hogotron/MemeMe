//
//  BottomTextFieldDelegate.swift
//  MemeMe
//
//  Created by Tomas Sidenfaden on 7/13/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class BottomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = ""
        }
    }
}
