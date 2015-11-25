//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Garcia, Samuel on 22/11/15.
//  Copyright © 2015 SamuGar. All rights reserved.
//

import Foundation
import UIKit


class TextFieldDelegate: NSObject, UITextFieldDelegate {

    
    var defaultText = true
    
    //Clear textfield if default text
    
    func textFieldDidBeginEditing(textField: UITextField){
        if defaultText
        {
            textField.text = ""
            defaultText = false
        }
    }
    
    //Dismiss keyboard on Enter presssed
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func backToDefault(){
        defaultText = true
    }
    
}