//
//  ContactsTableViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/29/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        cell.textLabel?.text = ""
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addContactButtonPressed(_ sender: Any) {
        presentAlert()
    }
    
    func presentAlert() {
        var nameTextField = UITextField()
        var phoneNumberTextField = UITextField()
        
        let alert = UIAlertController(title: "New Contact", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
            nameTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Contacts Phone Number"
            phoneNumberTextField = textField
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (sender) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
