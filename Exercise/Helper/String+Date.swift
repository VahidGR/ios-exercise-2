//
//  String+Date.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/27/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import Foundation

extension String {
    var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.date(from: self)!
    }
    
    var shortFormattedTime: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
}
