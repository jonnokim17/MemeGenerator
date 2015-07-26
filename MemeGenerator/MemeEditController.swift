//
//  MemeEditController.swift
//  MemeGenerator
//
//  Created by Jonathan Kim on 7/24/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import UIKit

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
        NSStrokeWidthAttributeName : 3.0
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: change the text color to WHITE
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.text = "TOP"

        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.text = "BOTTOM"

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
        //TODO: fix image capture bug when keyboard is present

        saveMeme()
        let controller = UIActivityViewController(activityItems: [meme!.memedImage!], applicationActivities: nil)
        presentViewController(controller, animated: true) { () -> Void in
            //TODO: Dismiss?
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

        if textField == topTextField {
            if topTextField.text == "TOP" {
                topTextField.text = ""
            }
        }

        if textField == bottomTextField {
            if bottomTextField.text == "BOTTOM" {
                bottomTextField.text = ""
            }
        }

        shareButton.enabled = true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if textField == topTextField {
            if topTextField.text == "" {
                topTextField.text = "TOP"
            }
        }

        if textField == bottomTextField {
            if bottomTextField.text == "" {
                bottomTextField.text = "BOTTOM"
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
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.editing == true {
            self.view.frame.origin.y += getKeyboardHeight(notification)
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

