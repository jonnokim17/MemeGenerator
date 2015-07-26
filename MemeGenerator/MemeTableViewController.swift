//
//  MemeTableViewController.swift
//  MemeGenerator
//
//  Created by Jonathan Kim on 7/25/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import UIKit

let reuseIdentifier = "customCell"

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var memes: [Meme]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes

        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customCell: MemeTableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeTableViewCell

        let meme: Meme = memes[indexPath.row] as Meme

        customCell.memeImageView.image = meme.memedImage
        customCell.topTextLabel.text = meme.topText
        customCell.bottomTextLabel.text = meme.bottomText

        return customCell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tableSegue") {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let indexPathRow = indexPath?.row
            let selectedMeme = memes[indexPathRow!]

            let navVC: UINavigationController = segue.destinationViewController as! UINavigationController
            let memeDetailVC: MemeDetailViewController = navVC.childViewControllers[0] as! MemeDetailViewController
            memeDetailVC.selectedMeme = selectedMeme
            navVC.hidesBottomBarWhenPushed = true
        }
    }
}
