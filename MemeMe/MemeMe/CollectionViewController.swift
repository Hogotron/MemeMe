//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Tomas Sidenfaden on 7/31/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var memes: [Meme]!
    var memeToEdit: Meme?
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 1.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (3 * space)) / 4.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func collectionView(_ collectionVvar: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let meme = self.memes[indexPath.row]
    
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        controller.memeToEdit = memes[indexPath.item]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "cancelFromCollectionToViewController", sender: self)
    }
}
