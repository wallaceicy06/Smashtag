//
//  TweetersTableViewController.swift
//  SmashTag
//
//  Created by Sean Harger on 10/20/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import UIKit
import CoreData

class TweetersTableViewController: CoreDataTableViewController<TwitterUser> {

    var mention: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }

    private func updateUI() {
        if let context = managedObjectContext, mention?.characters.count ?? 0 > 0 {
            let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            request.sortDescriptors = [
                NSSortDescriptor(key: "screenName",
                                 ascending: true,
                                 selector: #selector(NSString.caseInsensitiveCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }

    private func tweetCountWithMentionBy(twitterUser user: TwitterUser) -> Int? {
        var count: Int?
        user.managedObjectContext?.performAndWait {
            let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
            request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@",
                                            self.mention!,
                                            user)
            try? count = user.managedObjectContext?.count(for: request)
        }
        return count
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUserCell", for: indexPath)

        if let twitterUser = fetchedResultsController?.object(at: indexPath) {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait {
                screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
            if let count = tweetCountWithMentionBy(twitterUser: twitterUser) {
                cell.detailTextLabel?.text = (count == 1) ? "1 tweet" : "\(count) tweets"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }

        return cell
    }

}
