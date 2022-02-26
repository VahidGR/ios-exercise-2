//
//  Password.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/26/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import Foundation

struct Password: Codable {
    let lowercase: Bool
    let uppercase: Bool
    let number: Bool
    let isLong: Bool
    
    var isValid: Bool = false
    
    var rules: [Bool] = []
    
    init(lowercase: Bool, uppercase: Bool, number: Bool, isLong: Bool) {
        self.lowercase = lowercase
        rules.append(lowercase)
        self.uppercase = uppercase
        rules.append(uppercase)
        self.number = number
        rules.append(number)
        self.isLong = isLong
        rules.append(isLong)
        
        if lowercase && uppercase && number && isLong {
            self.isValid = true
        } else { self.isValid = false }
    }
}
