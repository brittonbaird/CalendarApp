//
//  CreateEventViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 10/11/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createEventButtonPressed(_ sender: Any) {
        if let startTime = startTimeTextField.text,
            let endTime = endTimeTextField.text,
            let date = dateTextField.text,
            let name = eventNameTextField.text,
            let details = detailsTextField.text,
            !startTime.isEmpty,
            !endTime.isEmpty,
            !date.isEmpty,
            !name.isEmpty,
            !details.isEmpty {
            
            UserController.shared.addEvent(withName: name, startTime: startTime, endTime: endTime, date: date, contacts: <#T##[String : Bool]#>, details: <#T##String#>, completion: <#T##() -> Void#>)
        }
        
    }
}
