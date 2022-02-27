//
//  Timestamp+formattedDate.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/27/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import Firebase

extension Timestamp {
    var formattedTime: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: dateValue())
    }
}
