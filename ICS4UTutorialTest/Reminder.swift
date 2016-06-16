//
//  Reminder.swift
//  ICS4UTutorialTest
//
//  Created by Eric Qiu on 2016-06-11.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import Foundation
import UIKit

class Reminder: NSObject, NSCoding {
    // Properties
    var notification: UILocalNotification
    var name: String
    var time: NSDate
    
    // Archive Paths for Persistent Data
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("reminders")
    
    // enum for property types
    struct PropertyKey {
        static let nameKey = "name"
        static let timeKey = "time"
        static let notificationKey = "notification"
    }
    
    // Initializer
    init(name: String, time: NSDate, notification: UILocalNotification) {
        // set properties
        self.name = name
        self.time = time
        self.notification = notification
        
        super.init()
    }
    
    // Destructor
    deinit {
        // cancel notification
        UIApplication.sharedApplication().cancelLocalNotification(self.notification)
    }
    
    // NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(time, forKey: PropertyKey.timeKey)
        aCoder.encodeObject(notification, forKey: PropertyKey.notificationKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let time = aDecoder.decodeObjectForKey(PropertyKey.timeKey) as! NSDate
        
        let notification = aDecoder.decodeObjectForKey(PropertyKey.notificationKey) as! UILocalNotification
        
        // Must call designated initializer.
        self.init(name: name, time: time, notification: notification)
    }
}