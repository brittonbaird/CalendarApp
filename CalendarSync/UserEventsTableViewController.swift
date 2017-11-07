//
//  UserEventsTableViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/31/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class UserEventsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userEventTimeCell", for: indexPath)

        let event = UserController.shared.events[indexPath.row]
        
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = "\(event.startTime) - \(event.endTime)"
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 2

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let event = UserController.shared.events[indexPath.row]
        
        if editingStyle == .delete {
            UserController.shared.deleteEvent(event: event, completion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let destinationViewController = segue.destination as? CreateEventViewController {
                if let index = tableView.indexPathForSelectedRow {
                    let event = UserController.shared.events[index.row]
                    destinationViewController.event = event
                    destinationViewController.startTime = event.startTime
                    destinationViewController.endTime = event.endTime
                    destinationViewController.name = event.name
                    destinationViewController.dateString = event.date
                    destinationViewController.details = event.details
                    
                }
            }
        }
    }
 
}
