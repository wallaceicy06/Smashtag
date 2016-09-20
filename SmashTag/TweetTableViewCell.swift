//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Sean Harger on 9/18/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!

    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }

    private var lastProfileImageUrlRequested: URL?

    private func updateUI() {
        // reset any existing tweet information
        tweetScreenNameLabel?.text = nil
        tweetTextLabel?.text = nil
        tweetCreatedLabel?.text = nil
        tweetProfileImageView?.image = nil

        // load new information about our tweet (if any)
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text == nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }

            tweetScreenNameLabel?.text = "\(tweet.user)"

            if let profileImageUrl = tweet.user.profileImageURL {
                lastProfileImageUrlRequested = profileImageUrl
                DispatchQueue.global(qos: .userInteractive).async { [weak weakSelf = self] in
                    if let imageData = try? Data(contentsOf: profileImageUrl) {
                        DispatchQueue.main.async {
                            if weakSelf?.lastProfileImageUrlRequested ??
                                   weakSelf?.lastProfileImageUrlRequested! == profileImageUrl {
                                weakSelf?.tweetProfileImageView?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }

            let formatter = DateFormatter()
            if Date().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)


        }
    }
}
