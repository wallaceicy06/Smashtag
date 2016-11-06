//
//  TweetQuery+CoreDataClass.swift
//  SmashTag
//
//  Created by Sean Harger on 11/5/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import Foundation
import CoreData
import Twitter

public class TweetQuery: NSManagedObject {

    class func tweetQueryWith(term: String,
                              tweets: [Twitter.Tweet],
                              inManagedContext context: NSManagedObjectContext) -> TweetQuery {
        let request: NSFetchRequest<TweetQuery> = TweetQuery.fetchRequest()
        request.predicate = NSPredicate(format: "term = %@", term)

        if let tweetQuery = (try? context.fetch(request))?.first {
            return addTweets(tweets, toQuery: tweetQuery, inManagedContext: context)
        } else {
            let newTweetQuery = TweetQuery(context: context)
            newTweetQuery.term = term
            return addTweets(tweets, toQuery: newTweetQuery, inManagedContext: context)
        }
    }

    private class func addTweets(_ tweets: [Twitter.Tweet],
                                toQuery query: TweetQuery,
                                inManagedContext context: NSManagedObjectContext) -> TweetQuery {
        for twitterInfo in tweets {
            query.addToTweets(Tweet.tweetWith(twitterInfo: twitterInfo,
                                              inManagedContext: context))
        }

        return query
    }

}
