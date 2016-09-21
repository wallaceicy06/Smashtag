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
        static let searchForTweets = "SearchTweets"
    }

    private var tweetInfoCells: [Array<Twitter.Mention>] {
        return [tweet.hashtags, tweet.userMentions, tweet.urls]
    }

    private var tweetInfoSectionNames = ["Hashtags", "Users", "URLs"]

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVc = segue.destination as? TweetTableViewController,
            let sendingQuery = sender as? String {
            destinationVc.searchText = sendingQuery
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetInfo", for: indexPath)

        cell.textLabel?.text = tweetInfoCells[indexPath.section][indexPath.item].keyword

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        // If there are no tweets in a section, do not display the header.
        if tweetInfoCells[section].count == 0 {
            return nil
        }

        // Otherwise, return the static section name.
        return tweetInfoSectionNames[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tweetInfoSectionNames[indexPath.section] {
        case "Hashtags":
            fallthrough
        case "Users":
            let query = tweetInfoCells[indexPath.section][indexPath.item].keyword
            performSegue(withIdentifier: Storyboard.searchForTweets, sender: query)
            break
        case "URLs":
            if let url = URL(string: tweetInfoCells[indexPath.section][indexPath.item].keyword) {
                UIApplication.shared.open(url)
            }
        default:
            break
        }
    }
}
