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
}
