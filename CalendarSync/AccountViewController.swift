//
//  AccountViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 9/15/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.pendingEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pendingRequestCell", for: indexPath)
        
        let event = UserController.shared.pendingEvents[indexPath.row]
        cell.textLabel?.text = "\(event.name): \(event.startTime) - \(event.endTime)"
        cell.detailTextLabel?.text = event.creator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let indexPath = editActionsForRowAt
        let event = UserController.shared.pendingEvents[indexPath.row]

        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            UserController.shared.pendingEvents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserController.shared.deletePendingEvent(event: event, completion: {})
        }
        delete.backgroundColor = .red
        
        let add = UITableViewRowAction(style: .destructive, title: "Add") { action, index in
            UserController.shared.pendingEvents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserController.shared.addPendingEvent(event: event, completion: {})
        }
        add.backgroundColor = .green
        
        return [delete, add]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

