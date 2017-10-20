//
//  HomeViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 9/12/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var pendingEventsCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserController.shared.loadNumberFromUserDefaults(key: "phoneNumber")
        UserController.shared.fetchUser(withID: UserController.shared.user.phoneNumber, completion: {} )
        
        UserController.shared.fetchContacts(completion: {})
        
        pendingEventsCount.layer.cornerRadius = 16
        pendingEventsCount.clipsToBounds = true
        
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserController.shared.pendingEvents.count == 0 {
            self.pendingEventsCount.isHidden = true
        }
        
        UserController.shared.fetchPendingEvents {
            DispatchQueue.main.async {
                if UserController.shared.pendingEvents.count > 0 {
                    self.pendingEventsCount.isHidden = false
                    self.pendingEventsCount.text = "\(UserController.shared.pendingEvents.count)"
                }
                
            }
        }
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toToday" {
            if let destinationViewController = segue.destination as? SplitViewsContainerViewController {
                let date = Date()
                destinationViewController.date = date
            }
        }
    }
 

}
