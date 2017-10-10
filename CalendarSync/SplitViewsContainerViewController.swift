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
    
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var userEventsList: UIView!
    @IBOutlet weak var contactEventsList: UIView!
    
    var date: Date? {
        didSet {
            formatter.dateFormat = "MMMM dd"
            self.navigationItem.title = formatter.string(from: date!)
        }
    }
    let formatter = DateFormatter()
    var contactEventsHidden: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        if contactEventsHidden {
            
        }
    }

    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}
