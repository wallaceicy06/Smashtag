//
//  TweetImageInspectorViewController.swift
//  SmashTag
//
//  Created by Sean Harger on 9/25/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit

class TweetImageInspectorViewController: UIViewController {

    var image: UIImage? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    private func updateUI() {
        imageView?.image = image
    }

}
