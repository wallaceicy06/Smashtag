//
//  Tweet+CoreDataProperties.swift
//  SmashTag
//
//  Created by Sean Harger on 11/6/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import Foundation
import CoreData

extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet")
    }

    @NSManaged public var posted: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var unique: String?
    @NSManaged public var mentions: NSSet?
    @NSManaged public var queries: NSSet?
    @NSManaged public var tweeter: TwitterUser?

}

// MARK: Generated accessors for mentions
extension Tweet {

    @objc(addMentionsObject:)
    @NSManaged public func addToMentions(_ value: Mention)

    @objc(removeMentionsObject:)
    @NSManaged public func removeFromMentions(_ value: Mention)

    @objc(addMentions:)
    @NSManaged public func addToMentions(_ values: NSSet)

    @objc(removeMentions:)
    @NSManaged public func removeFromMentions(_ values: NSSet)

}

// MARK: Generated accessors for queries
extension Tweet {

    @objc(addQueriesObject:)
    @NSManaged public func addToQueries(_ value: TweetQuery)

    @objc(removeQueriesObject:)
    @NSManaged public func removeFromQueries(_ value: TweetQuery)

    @objc(addQueries:)
    @NSManaged public func addToQueries(_ values: NSSet)

    @objc(removeQueries:)
    @NSManaged public func removeFromQueries(_ values: NSSet)

}
