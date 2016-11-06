//
//  Mention+CoreDataProperties.swift
//  SmashTag
//
//  Created by Sean Harger on 11/6/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import Foundation
import CoreData

extension Mention {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mention> {
        return NSFetchRequest<Mention>(entityName: "Mention")
    }

    @NSManaged public var keyword: String?
    @NSManaged public var tweet: NSSet?

}

// MARK: Generated accessors for tweet
extension Mention {

    @objc(addTweetObject:)
    @NSManaged public func addToTweet(_ value: Tweet)

    @objc(removeTweetObject:)
    @NSManaged public func removeFromTweet(_ value: Tweet)

    @objc(addTweet:)
    @NSManaged public func addToTweet(_ values: NSSet)

    @objc(removeTweet:)
    @NSManaged public func removeFromTweet(_ values: NSSet)

}
