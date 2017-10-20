//
//  CreateEventViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 10/11/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var includedContacts: [Contact]? {
        didSet {
            for contact in includedContacts! {
                contactList[contact.contactNumber] = contact.name
            }
        }
    }
    
    var event: Event?
    var availableTimes: [String] = []
    var allTimes: [String] = ["12:00 am", "1:00 am", "2:00 am", "3:00 am", "4:00 am", "5:00 am", "6:00 am", "7:00 am", "8:00 am", "9:00 am", "10:00 am", "11:00 am", "12:00 pm", "1:00 pm", "2:00 pm", "3:00 pm", "4:00 pm", "5:00 pm", "6:00 pm", "7:00 pm", "8:00 pm", "9:00 pm", "10:00 pm", "11:00 pm"]
    var pickerOptions1 = [["12:00", "1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00", "11:00"], ["am", "pm"]]
    var contactList: [String: String] = [:]
    var startTime: String = ""
    var endTime: String = ""
    var dateString: String = ""
    var name: String = ""
    var details: String = ""

    @IBOutlet weak var startTimeTextField: UITextField?
    @IBOutlet weak var endTimeTextField: UITextField?
    @IBOutlet weak var dateTextField: UITextField?
    @IBOutlet weak var eventNameTextField: UITextField?
    @IBOutlet weak var detailsTextField: UITextField?
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startTimePickerView = UIPickerView()
        let endTimePickerView = UIPickerView()
        startTimePickerView.delegate = self
        endTimePickerView.delegate = self
        startTimePickerView.tag = 1
        endTimePickerView.tag = 2
        startTimeTextField?.inputView = startTimePickerView
        endTimeTextField?.inputView = endTimePickerView
        
        let tapOutside = UITapGestureRecognizer(target: self, action: #selector(CreateEventViewController.dismissPicker))
        
        view.addGestureRecognizer(tapOutside)
        
        createButton.layer.cornerRadius = 14
        createButton.clipsToBounds = true
        
        updateViews()
    }
    
    func updateViews() {
        startTimeTextField?.text = startTime
        endTimeTextField?.text = endTime
        dateTextField?.text = dateString
        if name != "" {
            eventNameTextField?.text = name
            detailsTextField?.text = details
            startTimeTextField?.isEnabled = false
            endTimeTextField?.isEnabled = false
            dateTextField?.isEnabled = false
            eventNameTextField?.isEnabled = false
            detailsTextField?.isEnabled = false
            createButton.setTitle("Delete", for: .normal)
            createButton.backgroundColor = .red
        }
    }
    
    @IBAction func createEventButtonPressed(_ sender: Any) {
        if createButton.currentTitle == "Delete" {
            guard let event = event else { return }
            UserController.shared.deleteEvent(event: event, completion: {})
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        if let startTime = startTimeTextField?.text,
            let endTime = endTimeTextField?.text,
            let date = dateTextField?.text,
            let name = eventNameTextField?.text,
            let details = detailsTextField?.text,
            !startTime.isEmpty,
            !endTime.isEmpty,
            !date.isEmpty,
            !name.isEmpty {
            
            if availableTimes.contains(startTime) {
                
                guard let index1 = allTimes.index(of: startTime), let index2 = allTimes.index(of: endTime) else { return }
                for i in index1..<index2 {
                    if !availableTimes.contains(allTimes[i]) {
                        presentAlert(withName: "Time requested is unavailable")
                        return
                    }
                }
                
                UserController.shared.addEvent(withName: name, startTime: startTime, endTime: endTime, date: date, contacts: ["info": contactList], details: details, creator: UserController.shared.user.name, completion: {
                    DispatchQueue.main.async {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            } else {
                presentAlert(withName: "Time requested is unavailable")
            }
            
        } else {
            presentAlert(withName: "Please fill all required fields")
        }
        
    }
    
    func presentAlert(withName name: String) {
        
        let alert = UIAlertController(title: name, message: "", preferredStyle: .alert)
    
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerOptions1.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions1[component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions1[component][row]
    }
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let time = pickerOptions1[0][pickerView.selectedRow(inComponent: 0)]
            let amPm = pickerOptions1[1][pickerView.selectedRow(inComponent: 1)]
            startTimeTextField?.text = time + " " + amPm
        }
        
        if pickerView.tag == 2 {
            let time = pickerOptions1[0][pickerView.selectedRow(inComponent: 0)]
            let amPm = pickerOptions1[1][pickerView.selectedRow(inComponent: 1)]
            endTimeTextField?.text = time + " " + amPm
        }
    }
}
