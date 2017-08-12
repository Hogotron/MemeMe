//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Tomas Sidenfaden on 7/31/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Declare variables
    
    var memes: [Meme]!
    var memeToEdit: Meme?
    
    // MARK: Declare outlets
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Declare dimension variables
        let space:CGFloat = 1.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (3 * space)) / 4.0
        
        // Apply dimension variables
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Load memes from App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        collectionView?.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionVvar: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let meme = self.memes[indexPath.row]
    
        cell.memeImageView.image = meme.memedImage
        
        formatImageView(imageView: cell.memeImageView)
        
        return cell
    }
    

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        controller.memeToEdit = memes[indexPath.item]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func addButton(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.present(controller, animated: true, completion: nil)
    }
}
