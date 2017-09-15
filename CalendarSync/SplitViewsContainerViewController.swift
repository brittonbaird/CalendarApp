//
//  SplitViewsContainerViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/31/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SplitViewsContainerViewController: UIViewController {
    
    var date: Date? {
        didSet {
            navigationItem.title = date?.description
        }
    }
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    
    var contactEventsHidden: Bool = true
    let userEvents = UserEventsTableViewController()
    let contactsEvents = ContactsEventsTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = false
        
        if contactEventsHidden {
            
        }
        
        addChildViewController(userEvents)
        addChildViewController(contactsEvents)
    }

    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}
