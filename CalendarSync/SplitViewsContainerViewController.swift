//
//  SplitViewsContainerViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/31/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class SplitViewsContainerViewController: UIViewController {
    
    var contactEventsHidden: Bool = true
    let userEvents = UserEventsTableViewController()
    let contactsEvents = ContactsEventsTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if contactEventsHidden {
            
        }
        
        addChildViewController(userEvents)
        addChildViewController(contactsEvents)
    }

    

}
