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

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async {
            self.setUpCalendar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func setUpCalendar() {
        calendarView.visibleDates { (visibleDates) in
            self.setCalendarTitle(visibleDates: visibleDates)
        }
    }

    func setCalendarTitle(visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        
        formatter.dateFormat = "MMMM yyyy"
        self.navigationItem.title = formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDate" {
            if let destinationViewController = segue.destination as? SplitViewsContainerViewController {
                if let indexPath = calendarView.indexPath(for: sender as! JTAppleCell) {
                    let date = calendarView.cellStatusForDate(at: 0, column: indexPath.row)?.date
                    destinationViewController.date = date
                    destinationViewController.homeButton.title = "Back"
                }
            }
        }
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState) {
        guard let calendarCell = cell as? CalendarCell else { return }
        
        if cellState.dateBelongsTo == .thisMonth {
            calendarCell.dateLabel.alpha = 1.0
        } else {
            calendarCell.dateLabel.alpha = 0.3
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = Date()
        guard let endDate = formatter.date(from: "2017 12 31")
            else { return ConfigurationParameters(startDate: Date(), endDate: Date())}
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
       
        return parameters
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as? CalendarCell else { return JTAppleCell() }
        
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setCalendarTitle(visibleDates: visibleDates)
    }
    
}



