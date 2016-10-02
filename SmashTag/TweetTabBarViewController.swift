//
//  TweetTabBarViewController.swift
//  SmashTag
//
//  Created by Sean Harger on 10/1/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit

class TweetTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        // Find the tweet table view controller and the search history delegate in the list of tabs
        // for this view controller. Set the table view controller's search history delegate to the
        // one that was found.
        if let tweetTableVc = self.viewControllers?.first(
                where: {(controller) in
                    return controller.contentViewController is TweetTableViewController
                })?.contentViewController as? TweetTableViewController,
            let searchHistoryDelegate = self.viewControllers?.first(
                where: {(controller) in
                    return controller.contentViewController is SearchHistoryDelegate
                })?.contentViewController as? SearchHistoryDelegate {
            tweetTableVc.searchHistoryDelegate = searchHistoryDelegate
        }
    }
}
