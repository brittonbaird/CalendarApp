//
//  Contact.swift
//  CalendarSync
//
//  Created by Britton Baird on 10/9/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import Foundation

class Contact {
    
    private var nameKey = "name"
    private var contactNumberKey = "contactNumber"
    
    let name: String
    let contactNumber: String
    
    init(name: String, contactNumber: String) {
        self.name = name
        self.contactNumber = contactNumber
    }
    
    init?(jsonDictionary: [String: Any], userID: String, phoneNumber: String) {
        guard let name = jsonDictionary[nameKey] as? String,
            let contactNumber = jsonDictionary[contactNumberKey] as? String
            else { return nil }
        
        self.name = name
        self.contactNumber = contactNumber
    }
    
    var dictionaryRepresentation: [String: Any] {
        return [nameKey: name]
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: dictionaryRepresentation, options: .prettyPrinted)
    }
    
    
}
