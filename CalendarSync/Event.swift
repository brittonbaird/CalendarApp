//
//  Event.swift
//  CalendarSync
//
//  Created by Britton Baird on 9/11/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import Foundation

class Event {
    
    var startDate: Date
    var endDate: Date
    var contacts: [User]
    var name: String
    var details: String
    
    init(startDate: Date, endDate: Date, contacts: [User], name: String, details: String = "") {
        self.startDate = startDate
        self.endDate = endDate
        self.contacts = contacts
        self.name = name
        self.details = details
    }
}
