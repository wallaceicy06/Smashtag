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

    private struct TextAttributes {
        static let hashtag = [NSForegroundColorAttributeName : UIColor.brown]
        static let url = [NSForegroundColorAttributeName: UIColor.blue]
        static let user = [NSForegroundColorAttributeName: UIColor.orange]
    }

    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }

    private var lastProfileImageUrlRequested: URL?

    private func makeAttributedString(fromText text: String,
                                      withHashtags hashtags: [Twitter.Mention],
                                      withUrls urls: [Twitter.Mention],
                                      withUserMentions users: [Twitter.Mention])
        -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)

        for hashTag in hashtags {
            attributedString.replaceCharacters(in: hashTag.nsrange,
                                               with: NSAttributedString(
                                                string: hashTag.keyword,
                                                attributes: TextAttributes.hashtag))
        }

        for url in urls {
            attributedString.replaceCharacters(in: url.nsrange,
                                               with: NSAttributedString(
                                                string: url.keyword,
                                                attributes: TextAttributes.url))
        }

        for user in users {
            attributedString.replaceCharacters(in: user.nsrange,
                                               with: NSAttributedString(
                                                string: user.keyword,
                                                attributes: TextAttributes.user))

        }

        return attributedString
    }

    private func updateUI() {
        // reset any existing tweet information
        tweetScreenNameLabel?.text = nil
        tweetTextLabel?.text = nil
        tweetCreatedLabel?.text = nil
        tweetProfileImageView?.image = nil

        // load new information about our tweet (if any)
        if let tweet = self.tweet {
            tweetTextLabel?.attributedText =
              makeAttributedString(
                fromText: tweet.text,
                withHashtags: tweet.hashtags,
                withUrls: tweet.urls,
                withUserMentions: tweet.userMentions)

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
