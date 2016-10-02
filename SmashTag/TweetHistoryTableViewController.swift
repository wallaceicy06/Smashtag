//
//  TweetHistoryTableViewController.swift
//  SmashTag
//
//  Created by Sean Harger on 10/1/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit

class TweetHistoryTableViewController: UITableViewController, SearchHistoryDelegate {

    private struct Constants {
        static let maxTweetHistory = 100
    }

    private var tweetHistory = [String]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    private struct Storyboard {
        static let historicalTweetCellIdentifier = "HistoricalSearch"
    }

    // MARK: SearchHistoryDelegate

    func didSearchFor(query: String) {
        tweetHistory.insert(query, at: 0)
        if tweetHistory.count > Constants.maxTweetHistory {
            tweetHistory.remove(at: Constants.maxTweetHistory)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetHistory.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Storyboard.historicalTweetCellIdentifier,
            for: indexPath)

        cell.textLabel?.text = tweetHistory[indexPath.item]

        return cell
    }

}
