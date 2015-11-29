//
//  ViewController.swift
//  MemeMe
//
//  Created by Garcia, Samuel on 21/11/15.
//  Copyright © 2015 SamuGar. All rights reserved.
//


//ToDo: Test on real iPhone
//ToDo: Fix compilation codes


import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var textTop: UITextField!
    
    let textTopDefault = "TOP"
    let textBottomDefault = "BOTTOM"
    
    let pickerController = UIImagePickerController()
    
    let topTextFieldDelegate = TextFieldDelegate()
    let bottomTextFieldDelegate = TextFieldDelegate()
    
    
    
    //Initialization method overrides
    
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
        
        //Textfields Initial setup
        
        setTextField(textTop, delegate:topTextFieldDelegate, initialText: textTopDefault)
        setTextField(textBottom, delegate:bottomTextFieldDelegate, initialText: textBottomDefault)
        
        //Disables Share button until image selected
        
        shareButton.enabled = false
        
        //Disables camera button if camera not available
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    //Hide iOS status bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    //Toolbar button actions

    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        pickerController.sourceType = .PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        pickerController.sourceType = .Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        let memedimage = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [memedimage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {
            
            (activityType, completed, items, error) in
            
            if completed {
                
                //Save Meme in object for Meme 2.0 (unused object on 1.0)
                let meme = Meme(topText: self.textTop.text, bottomText: self.textBottom.text, image: self.imagePickerView.image, memedImage: memedimage)
                
                controller.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        setTextField(textTop, delegate:topTextFieldDelegate, initialText: textTopDefault)
        setTextField(textBottom, delegate:bottomTextFieldDelegate, initialText: textBottomDefault)
        
        imagePickerView.image = nil
        
        shareButton.enabled = false
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
    
    
    //Keyboard notification subscription/unsubscription and will show/hide behaviors

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
    
    func keyboardWillShow(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            
            //Only lift frame if originally down
            //Avoids lifting the frame twice on rotation while kbd is up
            if (view.frame.origin.y == 0)
                {
                    view.frame.origin.y -= getKeyboardHeight(notification)
                }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //Generates memed Image
    
    func generateMemedImage() -> UIImage {
        
        //Hide bars
        toolbarTop.hidden = true
        toolbarBottom.hidden = true
        
        //Take screen capture
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Unhide bars
        toolbarTop.hidden = false
        toolbarBottom.hidden = false
        
        return memedImage
    }
    
    //Initialise text fields
    
    func setTextField(field: UITextField!, delegate: TextFieldDelegate, initialText: String!){
        
        delegate.backToDefault()
        field.delegate = delegate
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5
        ]

        field.defaultTextAttributes = memeTextAttributes
        field.textAlignment = .Center
        field.text = initialText
        
    }


}
