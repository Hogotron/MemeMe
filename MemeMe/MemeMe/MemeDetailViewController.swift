//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Tomas Sidenfaden on 8/11/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Variables
    
    var memeToEdit: Meme?
    
    // MARK: Outlets
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        memeImageView.image = memeToEdit?.memedImage
        memeImageView.contentMode = .scaleAspectFit
    }
    
    @IBAction func editAction(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.present(controller, animated: true, completion: nil)
    }

    deinit {
        print("MemeDetailViewController was deinitialized")
    }
    
}
