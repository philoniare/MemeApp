//
//  ViewController.swift
//  meme1
//
//  Created by Philoniare on 3/8/16.
//  Copyright © 2016 philoniare. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var mainImg: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 2.0
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topText.delegate = self
        bottomText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
    }

    override func viewWillAppear(animated: Bool) {
//        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

        imagePicker.delegate = self
        self.subscribeToKeyboardNotifications("keyboardWillShow:", keyboardEventName: UIKeyboardWillShowNotification)
        self.subscribeToKeyboardNotifications("keyboardWillHide:", keyboardEventName: UIKeyboardWillHideNotification)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickImage(sender: AnyObject) {

        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainImg.contentMode = .ScaleToFill
            mainImg.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func takeImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("Start \(self.view.frame.origin.y)")
        self.view.frame.origin.y = 0
        print("End \(self.view.frame.origin.y)")
    }
    
    func subscribeToKeyboardNotifications(selector: Selector, keyboardEventName: String) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: keyboardEventName, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func save() {
        // Create a meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: mainImg.image, memedImage: generateMemedImage())
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        
        return memedImage
    }
    
    
    // Inside Memes table and Collection Views
//    var memes: [Meme]!
//    override func viewWillAppear() {
//        super.viewWillAppear()
//        let object = UIApplication.sharedApplication().delegate as AppDelegate
//        let appDelegate = object as AppDelegate
//        memes = appDelegate.memes
//    }

}

struct Meme {
    var topText: String
    var bottomText: String
    var image: UIImage?
    var memedImage: UIImage?
    
    init(topText: String, bottomText: String, image: UIImage?, memedImage: UIImage?){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
    
}
