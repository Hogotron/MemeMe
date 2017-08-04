//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Tomas Sidenfaden on 7/31/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var memes: [Meme]!
    var memeToEdit: Meme?
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if memes.isEmpty {
            if memeToEdit == nil {
                performSegue(withIdentifier: "showMemeFromCollectionView", sender: self)
            }
        }
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
        self.performSegue(withIdentifier: "showMemeFromCollectionView", sender: self)
    }
}
