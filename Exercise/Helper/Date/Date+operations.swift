//
//  Date+operations.swift
//  Exercise
//
//  Created by Vahid Ghanbarpour on 2/27/22.
//  Copyright © 2022 Matthias Nagel. All rights reserved.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
