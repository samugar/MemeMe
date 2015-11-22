//
//  TopTextDelegate.swift
//  MemeMe
//
//  Created by Garcia, Samuel on 22/11/15.
//  Copyright © 2015 SamuGar. All rights reserved.
//

import Foundation
import UIKit


class TopTextDelegate: NSObject, UITextFieldDelegate {

    var textEdited = false
    
    func textFieldDidBeginEditing(textField: UITextField){
        if !textEdited
        {
            textField.text = ""
            textEdited = true
        }
    }
    
}