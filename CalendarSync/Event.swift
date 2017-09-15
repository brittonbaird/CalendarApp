//
//  Event.swift
//  CalendarSync
//
//  Created by Britton Baird on 9/11/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import Foundation

class Event {
    
    private var startDateKey = "startDate"
    private var endDateKey = "endDate"
    private var contactsKey = "contacts"
    private var nameKey = "name"
    private var detailsKey = "details"
    
    var startDate: Date
    var endDate: Date
    var contacts: [String: Bool]
    var name: String
    var details: String
    
    init(startDate: Date, endDate: Date, contacts: [String: Bool], name: String, details: String = "") {
        self.startDate = startDate
        self.endDate = endDate
        self.contacts = contacts
        self.name = name
        self.details = details
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [startDateKey: startDate, endDateKey: endDate, contactsKey: contacts, nameKey: name, detailsKey: details]
    }
}
