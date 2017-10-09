//
//  User.swift
//  CalendarSync
//
//  Created by Britton Baird on 8/28/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import Foundation

class User {
    
    private var nameKey = "name"
    private var emailKey = "email"
    private var contactsKey = "contacts"
    private var eventsKey = "events"
    
    let name: String
    let email: String
    let phoneNumber: String
    let userID: String
    let contacts: [String]
    
    init(name: String = "", email: String = "", phoneNumber: String = "", userID: String = "", contacts: [String] = []) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.userID = userID
        self.contacts = contacts
    }
    
    init?(jsonDictionary: [String: Any], userID: String, phoneNumber: String) {
        guard let name = jsonDictionary[nameKey] as? String,
            let email = jsonDictionary[emailKey] as? String,
            let contacts = jsonDictionary[contactsKey] as? [String]
            else { return nil }
        
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.userID = userID
        self.contacts = contacts
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [nameKey: name, emailKey: email, contactsKey: contacts]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
}
