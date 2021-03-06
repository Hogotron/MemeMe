//
//  ViewController.swift
//  MemeMe
//
//  Created by Tomas Sidenfaden on 7/12/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import UIKit
import AVFoundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UICollectionViewDelegate {

    var meme = [Meme]()
    var memeToEdit: Meme?
    
    // MARK: Add outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
  
    // MARK: Text field delegate objects

    let textFieldDelegate = TextFieldDelegate()
    
    // MARK: Declare default text attributes
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.5
    ]
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController view is being loaded")
        prepareTextField(textField: topTextField)
        prepareTextField(textField: bottomTextField)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        if memeToEdit != nil {
            imagePickerView.image = memeToEdit?.originalImage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear is being called")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.memes.isEmpty {
                print("meme array is empty")
        if memeToEdit != nil {
            topTextField.text = memeToEdit?.topText
            bottomTextField.text = memeToEdit?.bottomText
                }
        }
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
    }
    
    // MARK: Implement imagePicker functions
    
    func presentImagePickerWithSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
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
            // Provide image loading error message
            print("Image loading failed")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Format text fields
    
    func prepareTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = textFieldDelegate
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
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        presentImagePickerWithSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        presentImagePickerWithSourceType(sourceType: .camera)
    }
    
    // MARK: Save data
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
}

