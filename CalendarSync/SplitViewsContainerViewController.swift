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
    
    var date: Date? {
        didSet {
            formatter.dateFormat = "MMMM dd"
            self.navigationItem.title = formatter.string(from: date!)
        }
    }
    let formatter = DateFormatter()
    var includedContacts: [Contact] = []
    var contactEventsHidden: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        if contactEventsHidden {
            contactEventsList.isHidden = true
        } else {
            contactEventsList.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if contactEventsHidden {
            contactEventsList.isHidden = true
        } else {
            contactEventsList.isHidden = false
        }
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
    }
}

extension SplitViewsContainerViewController: PeopleToIncludeTableViewControllerDelegate {
    func contactsSelected(contacts: [Contact], contactEventsHidden: Bool) {
        self.includedContacts = contacts
        self.contactEventsHidden = contactEventsHidden
    }
}
