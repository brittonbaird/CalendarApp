//
//  ContactsTableViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/29/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    let digits = CharacterSet.decimalDigits

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = UserController.shared.contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.contactNumber
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let contact = UserController.shared.contacts[indexPath.row]
        
        if editingStyle == .delete {
            UserController.shared.deleteContact(contact: contact, completion: {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addContactButtonPressed(_ sender: Any) {
        self.presentAlert()
    }
    
    func presentAlert() {
        var nameTextField = UITextField()
        var phoneNumberTextField = UITextField()
        
        let alert = UIAlertController(title: "New Contact", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            nameTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Phone Number (10 Digits)"
            phoneNumberTextField = textField
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (sender) in
            if let phoneNumber = phoneNumberTextField.text,
                let name = nameTextField.text,
                phoneNumber != "",
                name != "",
                phoneNumber.characters.count == 10 {
                for char in phoneNumber.unicodeScalars {
                    if !self.digits.contains(char) {
                        self.presentAlert(withName: "Only numbers can be used when entering a phone number")
                        return
                    }
                }
                UserController.shared.fetchNumber(withID: phoneNumber, completion: { (success) in
                    if success{
                        for contact in UserController.shared.contacts {
                            if contact.contactNumber == phoneNumber {
                                self.presentAlert(withName: "You already have a contact with that number")
                                return
                            }
                        }
                        
                        UserController.shared.addContact(withPhoneNumber: phoneNumber, name: name, completion: {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        })
                        return
                    } else {
                        self.presentAlert(withName: "No account found with that number")
                    }
                })
            } else {
                self.presentAlert(withName: "Please make sure the phone number is 10 characres and that each field is filled out")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func presentAlert(withName name: String) {
        
        let alert = UIAlertController(title: name, message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
