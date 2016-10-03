//
//  TweetInspectorTableViewController.swift
//  SmashTag
//
//  Created by Sean Harger on 9/20/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit
import Twitter

class TweetInspectorTableViewController: UITableViewController {

    var tweet: Tweet! {
        didSet {
            tableView.reloadData()
        }
    }

    struct Storyboard {
        static let returnToSearchSegue = "ReturnToSearch"
        static let inspectImageSegue = "InspectImage"
        static let tweetImageCellIdentifier = "TweetImage"
        static let tweetImageViewTag = 1
        static let tweetInfoCellIdentifier = "TweetInfo"
    }

    enum Section {
        case image
        case hashtag
        case user
        case url
    }

    private let nameForSection: [Section:String] = [
        .image: "Images",
        .hashtag: "Hashtags",
        .user: "Users",
        .url: "URLs"
    ]

    private var tweetInfoCells: [Array<AnyObject>] {
        return [tweet.media, tweet.hashtags, tweet.userMentions, tweet.urls]
    }

    private let tweetInfoSections: [Section] = [.image, .hashtag, .user, .url]

    private var imageForUrl = [URL: UIImage]()

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVc = segue.destination as? TweetTableViewController,
            let sendingQuery = sender as? String {
            destinationVc.searchText = sendingQuery
        } else if let destinationVc = segue.destination as? TweetImageInspectorViewController,
            let sendingImage = sender as? UIImage {
            destinationVc.image = sendingImage
        }
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweetInfoCells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetInfoCells[section].count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = tweetInfoCells[indexPath.section][indexPath.item]

        switch tweetInfoSections[indexPath.section] {
        case .image:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Storyboard.tweetImageCellIdentifier,
                for: indexPath)
            if let mediaItem = cellInfo as? Twitter.MediaItem {
                DispatchQueue.global(qos: .userInteractive).async { [weak weakSelf = self] in
                    if let imageData = try? Data(contentsOf: mediaItem.url) {
                        let image = UIImage(data: imageData)
                        weakSelf?.imageForUrl[mediaItem.url] = image
                        DispatchQueue.main.async {
                            if let imageView = cell.viewWithTag(Storyboard.tweetImageViewTag)
                                as? UIImageView {
                                imageView.image = image
                            }
                        }
                    }
                }
            }
            return cell
        case .hashtag, .url, .user:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Storyboard.tweetInfoCellIdentifier, for: indexPath)
            if let mention = cellInfo as? Twitter.Mention {
                cell.textLabel?.text = mention.keyword
            }
            return cell
        }
    }

    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        // If there are no tweets in a section, do not display the header.
        if tweetInfoCells[section].count == 0 {
            return nil
        }

        // Otherwise, return the static section name.
        return nameForSection[tweetInfoSections[section]]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch tweetInfoSections[indexPath.section] {
        case .hashtag:
            fallthrough
        case .user:
            let query = tweetInfoCells[indexPath.section][indexPath.item].keyword
            performSegue(withIdentifier: Storyboard.returnToSearchSegue, sender: query)
            break
        case .url:
            if let url = URL(string: tweetInfoCells[indexPath.section][indexPath.item].keyword) {
                UIApplication.shared.open(url)
            }
        case .image:
            if let mediaItem = tweetInfoCells[indexPath.section][indexPath.item]
                as? Twitter.MediaItem {
                if let image = imageForUrl[mediaItem.url] {
                    performSegue(withIdentifier: Storyboard.inspectImageSegue, sender: image)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tweetInfoSections[indexPath.section] {
        case .image:
            if let imageMedia = tweetInfoCells[indexPath.section][indexPath.row]
                as? Twitter.MediaItem {
                return tableView.bounds.width / CGFloat(imageMedia.aspectRatio)
            }
            fallthrough
        default:
            return UITableViewAutomaticDimension
        }
    }
}
