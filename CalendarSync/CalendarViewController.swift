//
//  CalendarViewController.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/30/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {

    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDate" {
            //if let destinationViewController = segue.destination as?
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        guard let startDate = formatter.date(from: "2017 01 01"),
            let endDate = formatter.date(from: "2017 12 31")
            else { return ConfigurationParameters(startDate: Date(), endDate: Date())}
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as? CalendarCell else { return JTAppleCell() }
        
        cell.dateLabel.text = cellState.text
        
        return cell
    }
    
    
}



