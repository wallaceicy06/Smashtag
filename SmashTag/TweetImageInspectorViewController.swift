//
//  TweetImageInspectorViewController.swift
//  SmashTag
//
//  Created by Sean Harger on 9/25/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit

class TweetImageInspectorViewController: UIViewController, UIScrollViewDelegate {

    struct ZoomConstants {
        static let maximumFactor = CGFloat(4.0)
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

        if imageView?.image != nil {
            let initialZoomScale = min(self.view.bounds.size.width / imageView.image!.size.width,
                                       self.view.bounds.size.height / imageView.image!.size.height)
            scrollView.minimumZoomScale = initialZoomScale
            scrollView.maximumZoomScale = initialZoomScale * ZoomConstants.maximumFactor
            scrollView.zoomScale = initialZoomScale
        }
    }

}
