//
//  ViewController.swift
//  MemeMe
//
//  Created by Garcia, Samuel on 21/11/15.
//  Copyright © 2015 SamuGar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var textTop: UITextField!
    
    let pickerController = UIImagePickerController()
    
    let topTextDelegate = TopTextDelegate()
    let bottomTextDelegate = BottomTextDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Definition of delegates

        pickerController.delegate = self
        
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
        textTop.delegate = topTextDelegate
        
        textBottom.defaultTextAttributes = memeTextAttributes
        textBottom.textAlignment = .Center
        textBottom.text = "BOTTOM"
        textBottom.delegate = bottomTextDelegate
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        
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
    
    //UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFit
            imagePickerView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    


}
