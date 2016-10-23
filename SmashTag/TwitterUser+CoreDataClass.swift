//
//  TwitterUser+CoreDataClass.swift
//  SmashTag
//
//  Created by Sean Harger on 10/20/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import Foundation
import CoreData
import Twitter


public class TwitterUser: NSManagedObject {

    class func twitterUserWith(twitterInfo: Twitter.User,
                               inManagedContext context: NSManagedObjectContext) -> TwitterUser? {
        let request: NSFetchRequest<TwitterUser> = TwitterUser.fetchRequest()
        request.predicate = NSPredicate(format: "screenName = %@", twitterInfo.screenName)

        if let twitterUser = (try? context.fetch(request))?.first {
            return twitterUser
        } else {
            let newUser = TwitterUser(context: context)
            newUser.screenName = twitterInfo.screenName
            newUser.name = twitterInfo.name
            return newUser
        }
    }
}
