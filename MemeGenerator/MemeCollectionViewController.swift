//
//  MemeCollectionViewController.swift
//  MemeGenerator
//
//  Created by Jonathan Kim on 7/25/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import UIKit

let collectionReuseID = "collectionCell"

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var memes: [Meme]!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes

        self.collectionView.reloadData()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MemeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionReuseID, forIndexPath: indexPath) as! MemeCollectionViewCell

        let meme: Meme = memes[indexPath.row] as Meme

        cell.memeImageView.image = meme.memedImage

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "collectionSegue") {
            let indexPath: AnyObject? = self.collectionView.indexPathsForSelectedItems().first
            let indexPathRow = indexPath?.row
            let selectedMeme = memes[indexPathRow!]

            let navVC: UINavigationController = segue.destinationViewController as! UINavigationController
            let memeDetailVC: MemeDetailViewController = navVC.childViewControllers[0] as! MemeDetailViewController
            memeDetailVC.selectedMeme = selectedMeme
            navVC.hidesBottomBarWhenPushed = true
        }
    }
}
