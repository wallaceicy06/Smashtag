//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Sean Harger on 9/18/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UISearchBarDelegate {

    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }

    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.text = searchText
        }
    }

    private var twitterRequest: Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }

    private var lastTwitterRequest: Twitter.Request?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchText = searchBar.text
    }

    @IBAction func refreshTweets(_ sender: UIRefreshControl) {
        if let request = lastTwitterRequest?.requestForNewer {
            makeTwitterRequest(for: request) {
                sender.endRefreshing()
            }
        } else {
            sender.endRefreshing()
        }
    }

    private func searchForTweets() {
        if let request = twitterRequest {
            makeTwitterRequest(for: request) {}
        }
    }

    private func makeTwitterRequest(for request: Twitter.Request,
                                    whenComplete callback: @escaping () -> Void) {
        lastTwitterRequest = request
        DispatchQueue.global(qos: .userInteractive).async {
            request.fetchTweets({ [weak weakSelf = self] (newTweets) in
                DispatchQueue.main.async(execute: {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, at: 0)
                        }
                    }
                    callback()
                })
            })
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier,
                                                 for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVc = segue.destination as? TweetInspectorTableViewController,
           let cellSender = sender as? UITableViewCell {
            if let cellIndexPath = tableView.indexPath(for: cellSender) {
                let tweetSender = tweets[cellIndexPath.section][cellIndexPath.item]
                destinationVc.tweet = tweetSender

            }
        }
    }

}
