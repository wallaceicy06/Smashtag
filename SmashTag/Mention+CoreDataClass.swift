//
//  Mention+CoreDataClass.swift
//  SmashTag
//
//  Created by Sean Harger on 11/5/16.
//  Copyright © 2016 Sean Harger Inc. All rights reserved.
//

import Foundation
import CoreData
import Twitter

public class Mention: NSManagedObject {

    class func mentionWith(twitterInfo: Twitter.Mention,
                           inManagedContext context: NSManagedObjectContext) -> Mention {
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()

        request.predicate = NSPredicate(
            format: "keyword =[c] %@",
            twitterInfo.keyword)

        if let mention = (try? context.fetch(request))?.first {
            return mention
        } else {
            let newMention = Mention(context: context)
            newMention.keyword = twitterInfo.keyword
            return newMention
        }
    }
}
