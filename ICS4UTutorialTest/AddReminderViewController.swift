//
//  AddReminderViewController.swift
//  ICS4UTutorialTest
//
//  Created by Eric Qiu on 2016-06-11.
//  Copyright © 2016 Eric Qiu. All rights reserved.
//

import UIKit

class AddReminderViewController: UIViewController, UITextFieldDelegate {
    var reminder: Reminder?

    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // set self as delegate for text field
        reminderTextField.delegate = self
        checkName()
        // set now as minimum date for picker
        timePicker.minimumDate = NSDate()
        timePicker.locale = NSLocale.currentLocale()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkName() {
        // Disable the Save button if the text field is empty.
        let text = reminderTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func checkDate() {
        // Disable the Save button if date has passed
        if NSDate().earlierDate(timePicker.date) == timePicker.date {
            saveButton.enabled = false
        }
    }
    
    // UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    // UIDatePickerDelegate
    @IBAction func timeChanged(sender: UIDatePicker) {
        checkDate()
    }
    
    // Cancel button
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if saveButton === sender {
            let name = reminderTextField.text
            var time = timePicker.date
            let timeInterval = floor(time.timeIntervalSinceReferenceDate/60)*60
            time = NSDate(timeIntervalSinceReferenceDate: timeInterval)
            
            // build notification
            let notification = UILocalNotification()
            notification.alertTitle = "Reminder"
            notification.alertBody = "Don't forget to \(name!)!"
            notification.fireDate = time
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            reminder = Reminder(name: name!, time: time, notification: notification)
        }
    }
    

}
