//
//  ContactsEventsTableViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/31/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class ContactsEventsTableViewController: UITableViewController {
    
    var eventTimes: [String] = ["12:00 am", "1:00 am", "2:00 am", "3:00 am", "4:00 am", "5:00 am", "6:00 am", "7:00 am", "8:00 am", "9:00 am", "10:00 am", "11:00 am", "12:00 pm", "1:00 pm", "2:00 pm", "3:00 pm", "4:00 pm", "5:00 pm", "6:00 pm", "7:00 pm", "8:00 pm", "9:00 pm", "10:00 pm", "11:00 pm"]
    
    var includedContacts: [Contact] = []
    var date: Date = Date()
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactEventTimeCell", for: indexPath)

        cell.textLabel?.text = "Available"
        cell.detailTextLabel?.text = eventTimes[indexPath.row]

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toAddEvent" {
                if let destinationViewController = segue.destination as? CreateEventViewController {
                    if let index = tableView.indexPathForSelectedRow {
                        destinationViewController.includedContacts = includedContacts
                        destinationViewController.startTime = eventTimes[index.row]
                        if eventTimes[index.row] == eventTimes.last {
                            destinationViewController.endTime = eventTimes[0]
                        } else {
                            destinationViewController.endTime = eventTimes[index.row + 1]
                        }
                        formatter.dateFormat = "MMMM dd yyyy"
                        destinationViewController.dateString = formatter.string(from: date)
                    }
                }
            }
    }

}
