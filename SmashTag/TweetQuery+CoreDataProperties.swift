//
//  TweetQuery+CoreDataProperties.swift
//  SmashTag
//
//  Created by Sean Harger on 11/6/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import Foundation
import CoreData

extension TweetQuery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TweetQuery> {
        return NSFetchRequest<TweetQuery>(entityName: "TweetQuery")
    }

    @NSManaged public var term: String?
    @NSManaged public var lastQueryTime: NSDate?
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for tweets
extension TweetQuery {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: Tweet)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: Tweet)

    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)

}
