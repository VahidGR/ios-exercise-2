//
//  Date+components.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/27/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import Foundation

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
}
