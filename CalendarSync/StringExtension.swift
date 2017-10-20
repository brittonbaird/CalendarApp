//
//  StringExtension.swift
//  CalendarSync
//
//  Created by Britton Baird on 10/18/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}
