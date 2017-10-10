//
//  PeopleToIncludeTableViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 9/15/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class PeopleToIncludeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "includeContactCell", for: indexPath) as? isIncludedTableViewCell else { return UITableViewCell() }
        
        let contact = UserController.shared.contacts[indexPath.row]
        
        cell.contactNameLabel.text = contact.name
        
        return cell
    }

}
