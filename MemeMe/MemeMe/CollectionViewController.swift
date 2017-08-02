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
        if memeToEdit == nil {
            performSegue(withIdentifier: "showMemeFromCollectionView", sender: self)
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
        let controller = self.storyboard?.instantiateInitialViewController() as! ViewController
        controller.meme = [self.memes[indexPath.row]]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMemeFromCollectionView" {
            
            let controller = segue.destination as! ViewController
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            memes = appDelegate.memes
        
            let indexPaths = collectionView!.indexpath
            // let firstSectionInIndex = indexPaths![0]
            controller.memeToEdit = appDelegate.memes[indexPaths.row]
 
        }
        
    }*/
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
