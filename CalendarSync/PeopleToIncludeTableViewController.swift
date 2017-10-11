//
//  PeopleToIncludeTableViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 9/15/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class PeopleToIncludeTableViewController: UITableViewController {
    
    var includedContacts: [Contact] = []
    weak var delegate: PeopleToIncludeTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        delegate?.contactsSelected(contacts: includedContacts, contactEventsHidden: false)
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "includeContactCell", for: indexPath) as? isIncludedTableViewCell else { return UITableViewCell() }
        
        let contact = UserController.shared.contacts[indexPath.row]
        cell.delegate = self
        cell.contactNameLabel.text = contact.name
        
        if includedContacts.contains(contact) {
            cell.isIncludedSwitch.isOn = true
        }
        
        return cell
    }

}

extension PeopleToIncludeTableViewController: isIncludedTableViewCellDelegate {
    func switchValueChanged(_ cell: isIncludedTableViewCell, selected: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let contact = UserController.shared.contacts[indexPath.row]
        if includedContacts.contains(contact) {
            guard let index = includedContacts.index(of: contact) else { return }
            includedContacts.remove(at: index)
        } else {
            includedContacts.append(contact)
        }
    }
}

protocol PeopleToIncludeTableViewControllerDelegate: class {
    func contactsSelected(contacts: [Contact], contactEventsHidden: Bool)
}
