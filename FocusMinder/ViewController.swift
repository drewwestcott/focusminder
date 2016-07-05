//
//  ViewController.swift
//  FocusMinder
//
//  Created by Drew Westcott on 12/05/2016.
//  Copyright © 2016 Drew Westcott. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let eventStore = EKEventStore()
    
    var Datasource = [Task]()
    
    @IBOutlet weak var needPermissionView: UIView!
    @IBOutlet weak var remindersTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        checkCalendarAuthorisation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func checkCalendarAuthorisation() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Reminder)
        
        switch(status) {
        case EKAuthorizationStatus.NotDetermined:
            //usually only first run
            requestAccessToCalendar()
        case EKAuthorizationStatus.Authorized:
            //We have access
            loadReminders()
            refreshReminderTable()
        case EKAuthorizationStatus.Denied:
            //Use has denied access
            needPermissionView.fadeIn()
        case EKAuthorizationStatus.Restricted:
            //Use has denied access
            needPermissionView.fadeIn()
        }
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccessToEntityType(EKEntityType.Reminder, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadReminders()
                    self.refreshReminderTable()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.needPermissionView.fadeIn()
                })
            }
        })
    }
    
    func loadReminders() {

        let predicate = eventStore.predicateForRemindersInCalendars([])
        eventStore.fetchRemindersMatchingPredicate(predicate) { tasks in
            for task in tasks! {
                let saveTask = Task(title: task.title, priority: task.priority)
                self.Datasource.append(saveTask)
                print("\(task.title) \(task.priority)")
            }}
    }
    
    func refreshReminderTable() {
        remindersTableView.hidden = false
        remindersTableView.reloadData()
    }
    
    @IBAction func goToSettings(sender: UIButton) {
        let openSettingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(openSettingsUrl!)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = remindersTableView.dequeueReusableCellWithIdentifier("pomodoroCell")
        
        cell!.textLabel?.text = Datasource[indexPath.row].title
        return cell!
    }
}

