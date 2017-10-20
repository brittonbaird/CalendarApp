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
        // Do any additional setup after loading the view.
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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
//        let event = UserController.shared.pendingEvents[indexPath.row]
        
//        if editingStyle == .delete {
//            UserController.shared.deletePendingEvent(event: event, completion: {
//                DispatchQueue.main.async {
//                    self.tableView.deleteRows(at: [indexPath], with: .fade)
//                    //self.tableView.reloadData()
//                }
//            })
//        } else if editingStyle == .insert {
//            UserController.shared.addPendingEvent(event: event, completion: {
//                DispatchQueue.main.async {
//                    UserController.shared.pendingEvents.remove(at: indexPath.row)
//                    self.tableView.reloadData()
//                }
//            })
//        }
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let indexPath = editActionsForRowAt
        let event = UserController.shared.pendingEvents[indexPath.row]

        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            UserController.shared.deletePendingEvent(event: event, completion: {
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    //self.tableView.reloadData()
                }
            })
        }
        delete.backgroundColor = .red
        
        let add = UITableViewRowAction(style: .destructive, title: "Add") { action, index in
            UserController.shared.addPendingEvent(event: event, completion: {
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
        }
        add.backgroundColor = .green
        
        return [delete, add]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

