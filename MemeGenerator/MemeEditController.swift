//
//  MemeEditController.swift
//  MemeGenerator
//
//  Created by Jonathan Kim on 7/24/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import UIKit

let defaultTopText = "TOP"
let defaultBottomText = "BOTTOM"
let emptyText = ""

class MemeEditController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraBarButton: UIBarButtonItem!
    @IBOutlet weak var chosenImage: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    var meme: Meme?
    var imagePicker = UIImagePickerController()

    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
        NSStrokeWidthAttributeName : -2.0
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.text = defaultTopText

        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.text = defaultBottomText

        if ((meme) != nil) {
            topTextField.text = meme?.topText
            bottomTextField.text = meme?.bottomText
            chosenImage.image = meme?.image
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraBarButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardHide()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeToKeyboardHide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
    }

    @IBAction func onAlbumButton(sender: UIBarButtonItem) {
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func onCamerButton(sender: UIBarButtonItem) {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func onShareBarButton(sender: UIBarButtonItem) {
        let controller = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        presentViewController(controller, animated: true) { () -> Void in
            controller.completionWithItemsHandler = { activity, success, items, error in
                if (success) {
                    self.saveMeme()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println("cancelled sharing")
                }
            }
        }
    }

    @IBAction func onCancelBarButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chosenImage.image = image
        }
        shareButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {

        if (meme != nil) {
            shareButton.enabled = true
        }

        if textField == topTextField {
            if topTextField.text == defaultTopText {
                topTextField.text = emptyText
            }
        }

        if textField == bottomTextField {
            if bottomTextField.text == defaultBottomText {
                bottomTextField.text = emptyText
            }
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if textField == topTextField {
            if topTextField.text == emptyText {
                topTextField.text = defaultTopText
            }
        }

        if textField == bottomTextField {
            if bottomTextField.text == emptyText {
                bottomTextField.text = defaultBottomText
            }
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true;
    }

    //Keyboard Shifting
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }

    func subscribeToKeyboardHide() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeToKeyboardHide() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing == true {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.editing == true {
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    //Save Meme
    func saveMeme() {
        meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, image: chosenImage.image!, memedImage: generateMemedImage())
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme!)

    }

    func generateMemedImage() -> UIImage {

        toolBar.hidden = true
        navigationController?.navigationBar.hidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        toolBar.hidden = false
        navigationController?.navigationBar.hidden = false

        return memedImage
    }
}

