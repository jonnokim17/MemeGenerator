//
//  Meme.swift
//  MemeGenerator
//
//  Created by Jonathan Kim on 7/25/15.
//  Copyright (c) 2015 Jonathan Kim. All rights reserved.
//

import Foundation
import UIKit

class Meme: NSObject {
    var topText: String?
    var bottomText: String?
    var image: UIImageView?
    var memedImage: UIImage?

    init(topText: String, bottomText: String, image: UIImageView, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}