//
//  NotificationTableViewController.swift
//  ICS4UTutorialTest
//
//  Created by Eric Qiu on 2016-06-11.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {
    // Properties
    var reminders = [Reminder]()
    let dateFormatter = NSDateFormatter()
    let locale = NSLocale.currentLocale()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        // load saved reminders, if any
        if let savedReminders = loadReminders() {
            reminders += savedReminders
        }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
        
    // Table view data
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "reminderCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) 
        
        let reminder = reminders[indexPath.row]
        // Fetches the appropriate info if reminder exists
        cell.textLabel?.text = reminder.name
        cell.detailTextLabel?.text = "Due " + dateFormatter.stringFromDate(reminder.time)
        
        // Make due date red if overdue
        if NSDate().earlierDate(reminder.time) == reminder.time {
            cell.detailTextLabel?.textColor = UIColor.redColor()
        }
        else {
            cell.detailTextLabel?.textColor = UIColor.blueColor()
        }
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let toRemove = reminders.removeAtIndex(indexPath.row)
            UIApplication.sharedApplication().cancelLocalNotification(toRemove.notification)
            saveReminders()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // NSCoding
    
    func saveReminders() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(reminders, toFile: Reminder.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save reminders...")
        }
    }
    
    func loadReminders() -> [Reminder]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Reminder.ArchiveURL.path!) as? [Reminder]
    }
    
    // When returning from AddReminderViewController
    @IBAction func unwindToReminderList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? AddReminderViewController, reminder = sourceViewController.reminder {
            // add a new reminder
            let newIndexPath = NSIndexPath(forRow: reminders.count, inSection: 0)
            reminders.append(reminder)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            saveReminders()
            tableView.reloadData()
        }
    }
}
