//
//  TweetImageInspectorViewController.swift
//  SmashTag
//
//  Created by Sean Harger on 9/25/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit

class TweetImageInspectorViewController: UIViewController, UIScrollViewDelegate {

    struct ScrollViewScale {
        static let minimumZoomScale = CGFloat(0.25)
        static let maximumZoomScale = CGFloat(4.0)
    }

    var image: UIImage? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = ScrollViewScale.minimumZoomScale
            scrollView.maximumZoomScale = ScrollViewScale.maximumZoomScale
        }
    }

    @IBOutlet weak var imageView: UIImageView!

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    private func updateUI() {
        imageView?.image = image
    }

}
