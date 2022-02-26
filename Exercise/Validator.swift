//
//  PasswordValidator.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/26/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import Foundation

final class Validator {
    func validateEmail(with srting: String) -> Bool {
        let rawEmail = email?.trimmingCharacters(
            in: .whitespaces
        )

        if let _ = rawEmail.flatMap(EmailAddress.init) {
            return true
        }
        
        return false
    }
    
    func validatePassword(with string: String) -> Bool {
        var uppercase = false
        var lowercase = false
        var number = false
        var isLong = false
        
        if string.count > 7 {
            isLong = true
        }
        
        for char in string {
            if char.isUppercase {
                uppercase = true
            }
        }
        
        for char in string {
            if char.isLowercase {
                lowercase = true
            }
        }
        
        for char in string {
            if let _ = Int(String(char)) {
                number = true
            }
        }
        
        let password = Password(lowercase: lowercase, uppercase: uppercase, number: number, isLong: isLong)
        
        return password.isValid
    }
}
