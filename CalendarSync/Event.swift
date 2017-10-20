//
//  Event.swift
//  CalendarSync
//
//  Created by Britton Baird on 9/11/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import Foundation

class Event {
    
    private var startTimeKey = "startTime"
    private var endTimeKey = "endTime"
    private var dateKey = "date"
    private var contactsKey = "contacts"
    private var nameKey = "name"
    private var detailsKey = "details"
    private var creatorKey = "creator"
    
    var startTime: String
    var endTime: String
    var date: String
    var contacts: [String: [String: String]]
    var name: String
    var details: String
    var creator: String
    
    init?(jsonDictionary: [String: Any]) {
        guard let startTime = jsonDictionary[startTimeKey] as? String,
            let endTime = jsonDictionary[endTimeKey] as? String,
            let date = jsonDictionary[dateKey] as? String,
            let contacts = jsonDictionary[contactsKey] as? [String: [String: String]],
            let name = jsonDictionary[nameKey] as? String,
            let details = jsonDictionary[detailsKey] as? String,
            let creator = jsonDictionary[creatorKey] as? String
            else { return nil }
        
        self.startTime = startTime
        self.endTime = endTime
        self.date = date
        self.contacts = contacts
        self.name = name
        self.details = details
        self.creator = creator
    }
    
    init(startTime: String, endTime: String, date: String, contacts: [String: [String: String]], name: String, details: String, creator: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.date = date
        self.contacts = contacts
        self.name = name
        self.details = details
        self.creator = creator
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [name: [startTimeKey: startTime, endTimeKey: endTime, dateKey: date, contactsKey: contacts, nameKey: name, detailsKey: details, creatorKey: creator]]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.name == rhs.name &&
            lhs.startTime == rhs.startTime &&
            lhs.endTime == rhs.endTime &&
            lhs.date == rhs.date
    }
}
