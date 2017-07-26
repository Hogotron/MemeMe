//
//  ViewController.swift
//  MemeMe
//
//  Created by Tomas Sidenfaden on 7/12/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Add outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: Text field delegate objects

    let topTextFieldDelegate = TopTextFieldDelegate()
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    // MARK: Declare default text attributes
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.5
    ]
    
    // MARK: Programmatic constraint variables
    
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    var topLeftConstraint: NSLayoutConstraint!
    var topRightConstraint: NSLayoutConstraint!
    var bottomLeftConstraint: NSLayoutConstraint!
    var bottomRightConstraint: NSLayoutConstraint!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextField(textField: topTextField)
        prepareTextField(textField: bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
        // Disable share button unless image is selected
        shareButton.isEnabled = imagePickerView.image == nil ? false : true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  layoutTextFields()
    }
    
    // MARK: Declare functions
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = .scaleAspectFit
        } else {
            print("Image loading failed")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func prepareTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        if textField == topTextField {
            textField.delegate = topTextFieldDelegate
        } else if textField == bottomTextField {
            textField.delegate = bottomTextFieldDelegate
        }
    }
    
    // MARK: Keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Shift view's frame up when keyboardWillShow notification is received
    
    func keyboardWillShow(_ notification: Notification) {
        if self.bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
            view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: This was my attempt to programmatically constrain text fields to image, so they would stay inside the image rather than float above and below it.
    

    /*
    func layoutTextFields() {
        
        if topConstraint != nil {
            view.removeConstraint(topConstraint)
        }
        if bottomConstraint != nil {
            view.removeConstraint(bottomConstraint)
        }
        if topLeftConstraint != nil {
            view.removeConstraint(topLeftConstraint)
        }
        if topRightConstraint != nil {
            view.removeConstraint(topRightConstraint)
        }
        if bottomLeftConstraint != nil {
            view.removeConstraint(bottomLeftConstraint)
        }
        if bottomRightConstraint != nil {
            view.removeConstraint(bottomRightConstraint)
        }
        

        let size = imagePickerView.image != nil ? imagePickerView.image!.size : imagePickerView.frame.size
        let frame = AVMakeRect(aspectRatio: size, insideRect: imagePickerView.bounds)
        
        let marginY = frame.origin.y + frame.size.height * 0.01
        let marginX = frame.origin.x + frame.size.width * 0.01
        
        topConstraint = NSLayoutConstraint(item: topTextField, attribute: .top, relatedBy: .equal, toItem: imagePickerView, attribute: .top, multiplier: 1.0, constant: marginY)
        view.addConstraint(topConstraint)
        
        bottomConstraint = NSLayoutConstraint(item: bottomTextField, attribute: .bottom, relatedBy: .equal, toItem: imagePickerView, attribute: .bottom, multiplier: 1.0, constant: -marginY)
        view.addConstraint(bottomConstraint)
                
        topLeftConstraint = NSLayoutConstraint(item: topTextField, attribute: .left, relatedBy: .equal, toItem: imagePickerView, attribute: .left, multiplier: 1.0, constant: marginX)
        view.addConstraint(topLeftConstraint)
        
        topRightConstraint = NSLayoutConstraint(item: topTextField, attribute: .right, relatedBy: .equal, toItem: imagePickerView, attribute: .right, multiplier: 1.0, constant: -marginX)
        view.addConstraint(topRightConstraint)
        
        bottomLeftConstraint = NSLayoutConstraint(item: bottomTextField, attribute: .left, relatedBy: .equal, toItem: imagePickerView, attribute: .left, multiplier: 1.0, constant: marginX)
        view.addConstraint(bottomLeftConstraint)
        
        bottomRightConstraint = NSLayoutConstraint(item: bottomTextField, attribute: .right, relatedBy: .equal, toItem: imagePickerView, attribute: .right, multiplier: 1.0, constant: -marginX)
        view.addConstraint(bottomRightConstraint)
    }
 */
   
    func hideToolbars(hide: Bool) {
        navBar.isHidden = hide
        toolBar.isHidden = hide
    }

    
    // MARK: Data management
    
    func generateMemedImage() -> UIImage {
        
        // Hide navbar and toolbar
        
        hideToolbars(hide: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navbar and toolbar
        
        hideToolbars(hide: false)
        
        return memedImage
        
    }
    
    @IBAction func share(_ sender: Any) {
        let memedImage: UIImage = generateMemedImage()
        let shareViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(shareViewController, animated: true, completion: nil)
        
        shareViewController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItemds: [Any]?, error: Error?) -> Void in
            if completed {
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }
}

