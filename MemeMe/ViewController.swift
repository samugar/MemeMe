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
    let textBottomDefault = "BOTTOM"
    let bottomTextFieldDelegate = TextFieldDelegate()
    
    @IBOutlet weak var textTop: UITextField!
    let textTopDefault = "TOP"
    let topTextFieldDelegate = TextFieldDelegate()
    
    let pickerController = UIImagePickerController()
    
    // Struct to save memes
    struct Meme {
        var textTop: String!
        var textBottom: String!
        var image: UIImage!
        var memedImage: UIImage!
    }
    
    
    //UI Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Used on initialization and on reset of interface elements

        imagePickerView.image = nil
        pickerController.delegate = self
        
        iniTextField(textTop, delegate:topTextFieldDelegate, initialText: textTopDefault)
        iniTextField(textBottom, delegate:bottomTextFieldDelegate, initialText: textBottomDefault)
        
        //Disables Share button until image selected
        
        shareButton.enabled = false
        
        //Disables camera button if camera not available
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    //Initialise text fields
    
    func iniTextField(field: UITextField!, delegate: TextFieldDelegate, initialText: String!){
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -5
        ]
        
        field.defaultTextAttributes = memeTextAttributes
        field.textAlignment = .Center
        field.text = initialText
        field.delegate = delegate
        
        delegate.backToDefault()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
        
        let memedImage = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {
            
            (activityType, completed, items, error) in
            
            if completed {
                
                //Need to pass parameters to saveMeme function as I already have the memedImage
                self.saveMeme(self.textTop.text, textBottom: self.textBottom.text, image: self.imagePickerView.image, memedImage: memedImage)
                
                controller.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        //Reset interface
        viewDidLoad()
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
            
            //Only move frame up if currently in origin 0
            //Avoids lifting the frame twice on rotation while keyboard is up
            if (view.frame.origin.y == 0)
                {
                    view.frame.origin.y -= getKeyboardHeight(notification)
                }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if textBottom.isFirstResponder() {
            
            //Move frame back to 0
            view.frame.origin.y = 0
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
    
    
    func saveMeme(textTop: String!, textBottom:String!, image:UIImage!, memedImage:UIImage!){
        
        //Just saving to the Meme struct for usage on MemeMe 2.0
        let meme = Meme(textTop: textTop, textBottom: textBottom, image: image, memedImage: memedImage)
    }
    
}
