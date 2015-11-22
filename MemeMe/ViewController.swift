//
//  ViewController.swift
//  MemeMe
//
//  Created by Garcia, Samuel on 21/11/15.
//  Copyright © 2015 SamuGar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var textTop: UITextField!
    
    let pickerController = UIImagePickerController()
    
    let topTextFieldDelegate = TextFieldDelegate()
    let bottomTextFieldDelegate = TextFieldDelegate()
    
    //let meme
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Definition of delegates

        pickerController.delegate = self
        textTop.delegate = topTextFieldDelegate
        textBottom.delegate = bottomTextFieldDelegate
        
        //UI Initial setup
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5
        ]

        textTop.defaultTextAttributes = memeTextAttributes
        textTop.textAlignment = .Center
        textTop.text = "TOP"
        
        textBottom.defaultTextAttributes = memeTextAttributes
        textBottom.textAlignment = .Center
        textBottom.text = "BOTTOM"
        
        //Disables Share button until image selected
        
        shareButton.enabled = false
        
        //Disables camera button if camera not available
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //Toolbar button actions

    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        pickerController.sourceType = .PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        pickerController.sourceType = .Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        
        //Just a test
        imagePickerView.image = generateMemedImage()

    }
    
    //UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFit
            imagePickerView.image = pickedImage
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //Keyboard notification subscription/unsubscription

    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:" , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:" , name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    //Keyboard show/hide behavior
    
    func keyboardWillShow(notification: NSNotification) {
        if (textBottom.isFirstResponder()) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (textBottom.isFirstResponder()) {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //Returns keyboard height
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    //Generates memed Image
    
    func generateMemedImage() -> UIImage {
        
        toolbarTop.hidden = true
        toolbarBottom.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbarTop.hidden = false
        toolbarBottom.hidden = false
        
        return memedImage
    }


}
