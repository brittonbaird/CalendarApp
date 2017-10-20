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
    var allTimes: [String] = ["12:00 am", "1:00 am", "2:00 am", "3:00 am", "4:00 am", "5:00 am", "6:00 am", "7:00 am", "8:00 am", "9:00 am", "10:00 am", "11:00 am", "12:00 pm", "1:00 pm", "2:00 pm", "3:00 pm", "4:00 pm", "5:00 pm", "6:00 pm", "7:00 pm", "8:00 pm", "9:00 pm", "10:00 pm", "11:00 pm"]
    
    var includedContacts: [Contact] = []
    var unavailableTimes: [String] = []
    var date: Date = Date()
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

//        let size = CGRect(x: 0, y: 0, width: 25, height: 25)
//        let tableViewTitle = UILabel(frame: size)
//        tableViewTitle.textColor = .white
//        tableViewTitle.backgroundColor = .black
//        tableViewTitle.textAlignment = .center
//        tableViewTitle.text = "Available Times"
//        tableView.tableHeaderView = tableViewTitle
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        eventTimes = ["12:00 am", "1:00 am", "2:00 am", "3:00 am", "4:00 am", "5:00 am", "6:00 am", "7:00 am", "8:00 am", "9:00 am", "10:00 am", "11:00 am", "12:00 pm", "1:00 pm", "2:00 pm", "3:00 pm", "4:00 pm", "5:00 pm", "6:00 pm", "7:00 pm", "8:00 pm", "9:00 pm", "10:00 pm", "11:00 pm"]
        
        for contact in includedContacts {
            UserController.shared.fetchContactEvents(contact: contact, date: date, completion: {
                DispatchQueue.main.async {
                    self.updateViews()
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func updateViews() {
        for event in UserController.shared.contactEvents {
            if eventTimes.contains(event.startTime) && eventTimes.contains(event.endTime) {
                guard let index = eventTimes.index(of: event.startTime),
                    let last = eventTimes.last
                    else { return }
                var i = index
                while eventTimes[i] != event.endTime && eventTimes[i] != last {
                    unavailableTimes.append(eventTimes[i])
                    i += 1
                }
                if eventTimes[i] == last {
                    unavailableTimes.append(eventTimes[i])
                }
            }
        }
        
        for event in UserController.shared.events {
            if eventTimes.contains(event.startTime) || eventTimes.contains(event.endTime) {
                guard let index = eventTimes.index(of: event.startTime),
                    let last = eventTimes.last
                    else { return }
                var i = index
                while eventTimes[i] != event.endTime && eventTimes[i] != last {
                    unavailableTimes.append(eventTimes[i])
                    i += 1
                }
                if eventTimes[i] == last {
                    unavailableTimes.append(eventTimes[i])
                }
            }
        }
        
        for time in unavailableTimes {
            if eventTimes.contains(time) {
                guard let index = eventTimes.index(of: time) else { return }
                eventTimes.remove(at: index)
            }
        }
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventTimes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactEventTimeCell", for: indexPath)

        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = eventTimes[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toAddEvent" {
                if let destinationViewController = segue.destination as? CreateEventViewController {
                    if let index = tableView.indexPathForSelectedRow {
                        destinationViewController.includedContacts = self.includedContacts
                        destinationViewController.startTime = eventTimes[index.row]
                        if eventTimes[index.row] == allTimes.last {
                            destinationViewController.endTime = allTimes[0]
                        } else {
                            guard let i = allTimes.index(of: eventTimes[index.row]) else { return }
                            destinationViewController.endTime = allTimes[i + 1]
                        }
                        formatter.dateFormat = "MMMM dd yyyy"
                        destinationViewController.dateString = formatter.string(from: date)
                        destinationViewController.availableTimes = eventTimes
                    }
                }
            }
    }

}
