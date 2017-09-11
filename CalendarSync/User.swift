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
    private var userIDKey = "userID"
    private var contactsKey = "contacts"
    
    let name: String
    let email: String
    let userID: String
    // add these in the user controller
    // let contacts: [User]
    // let events: [Event]
    
    init(name: String = "", email: String = "", userID: String = "") {
        self.name = name
        self.email = email
        self.userID = userID
    }
    
    init?(jsonDictionary: [String: Any], userID: String) {
        guard let name = jsonDictionary[nameKey] as? String,
            let email = jsonDictionary[emailKey] as? String
            else { return nil }
        
        self.name = name
        self.email = email
        self.userID = userID
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [nameKey: name, emailKey: email]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
}
