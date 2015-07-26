//
//  MemeDetailViewController.swift
//  MemeGenerator
//
//  Created by Jonathan Kim on 7/26/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    var selectedMeme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = selectedMeme.memedImage        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "onEditSegue" {
            let navVC: UINavigationController = segue.destinationViewController as! UINavigationController
            let memeEditVC: MemeEditController = navVC.childViewControllers[0] as! MemeEditController
            memeEditVC.meme = selectedMeme
        }
    }
}
