//
//  SplitViewsContainerViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/31/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SplitViewsContainerViewController: UIViewController {
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var userEventsList: UIView!
    @IBOutlet weak var contactEventsList: UIView!
    @IBOutlet weak var availableTimesLabel: UILabel!
    @IBOutlet weak var noEventsLabel: UILabel!
    
    var date: Date? {
        didSet {
            formatter.dateFormat = "MMMM dd"
            self.navigationItem.title = formatter.string(from: date!)
        }
    }
    let formatter = DateFormatter()
    var includedContacts: [Contact] = []
    var contactEventsHidden: Bool = true
    var userView = UserEventsTableViewController()
    var contactsView = ContactsEventsTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        guard let date = date else { return }
        UserController.shared.fetchEvents(date: date) {
            DispatchQueue.main.async {
                self.userView.tableView.reloadData()
                self.contactsView.tableView.reloadData()
                if UserController.shared.events.count == 0 {
                    self.noEventsLabel.isHidden = false
                }
            }
        }
        
       noEventsLabel.isHidden = true
        
        if self.contactEventsHidden {
            self.contactEventsList.isHidden = true
            self.availableTimesLabel.isHidden = true
        } else {
            self.contactEventsList.isHidden = false
            self.availableTimesLabel.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserController.shared.events = []
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddContacts" {
            if let destinationViewController = segue.destination as? PeopleToIncludeTableViewController {
                destinationViewController.delegate = self
                destinationViewController.includedContacts = self.includedContacts
            }
        }
        
        if segue.identifier == "showContactEvents" {
            if let destinationViewController = segue.destination as? ContactsEventsTableViewController {
                contactsView = destinationViewController
                destinationViewController.includedContacts = self.includedContacts 
                destinationViewController.date = self.date ?? Date()
            }
        }
        
        if segue.identifier == "showUserEvents" {
            if let destinationViewController = segue.destination as? UserEventsTableViewController {
                userView = destinationViewController
            }
        }
    }
}

extension SplitViewsContainerViewController: PeopleToIncludeTableViewControllerDelegate {
    func contactsSelected(contacts: [Contact], contactEventsHidden: Bool) {
        self.includedContacts = contacts
        self.contactEventsHidden = contactEventsHidden
    }
}
