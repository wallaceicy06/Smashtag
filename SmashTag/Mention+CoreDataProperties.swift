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
    @NSManaged public var tweet: Tweet?

}
