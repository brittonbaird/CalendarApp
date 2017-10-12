//
//  CreateEventViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 10/11/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    var includedContacts: [Contact] = []
    var contactList: [String: String] = [:]
    var startTime: String = ""
    var endTime: String = ""
    var dateString: String = ""

    @IBOutlet weak var startTimeTextField: UITextField?
    @IBOutlet weak var endTimeTextField: UITextField?
    @IBOutlet weak var dateTextField: UITextField?
    @IBOutlet weak var eventNameTextField: UITextField?
    @IBOutlet weak var detailsTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        startTimeTextField?.text = startTime
        endTimeTextField?.text = endTime
        dateTextField?.text = dateString
    }
    
    @IBAction func createEventButtonPressed(_ sender: Any) {
        if let startTime = startTimeTextField?.text,
            let endTime = endTimeTextField?.text,
            let date = dateTextField?.text,
            let name = eventNameTextField?.text,
            let details = detailsTextField?.text,
            !startTime.isEmpty,
            !endTime.isEmpty,
            !date.isEmpty,
            !name.isEmpty {
            
            for contact in includedContacts {
                contactList[contact.contactNumber] = contact.name
            }
            
            UserController.shared.addEvent(withName: name, startTime: startTime, endTime: endTime, date: date, contacts: ["contacts": contactList], details: details, completion: {})
            
            _ = self.navigationController?.popViewController(animated: true)
        } 
        
    }
}
