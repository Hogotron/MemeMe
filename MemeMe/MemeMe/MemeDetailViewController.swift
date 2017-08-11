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
    
    var memes = [Meme]()
    var memeToEdit: Meme?
    
    // MARK: Outlets
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        */
        
        self.tabBarController?.tabBar.isHidden = true
        
        memeImageView.image = memeToEdit?.memedImage
        memeImageView.contentMode = .scaleAspectFit
    }
    
    func backButton(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    deinit {
        print("MemeDetailViewController was deinitialized")
    }
    
}
