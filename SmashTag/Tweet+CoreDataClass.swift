//
//  Tweet+CoreDataClass.swift
//  SmashTag
//
//  Created by Sean Harger on 10/20/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import Foundation
import CoreData
import Twitter


public class Tweet: NSManagedObject {

    class func tweetWith(twitterInfo: Twitter.Tweet,
                         inManagedContext context: NSManagedObjectContext) -> Tweet? {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)

        if let tweet = (try? context.fetch(request))?.first {
            return tweet
        } else {
            let newTweet = Tweet(context: context)
            newTweet.unique = twitterInfo.id
            newTweet.text = twitterInfo.text
            newTweet.posted = twitterInfo.created as NSDate?
            newTweet.tweeter = TwitterUser.twitterUserWith(twitterInfo: twitterInfo.user,
                                                           inManagedContext: context)
            return newTweet
        }
    }
}
