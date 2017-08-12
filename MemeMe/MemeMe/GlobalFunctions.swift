//
//  GlobalFunctions.swift
//  MemeMe
//
//  Created by Tomas Sidenfaden on 8/11/17.
//  Copyright © 2017 Tomas Sidenfaden. All rights reserved.
//

import UIKit

func formatImageView(imageView: UIImageView) {
    imageView.layer.masksToBounds = true
    imageView.layer.borderColor = UIColor.black.cgColor
    imageView.layer.borderWidth = 1
}
