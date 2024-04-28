//
//  Expense.swift
//  SwiftUI-SwiftData-IOS17
//
//  Created by Daniel Felipe on 25/02/24.
//

import Foundation
import SwiftData

@Model
class Expense {
//    @Attribute(.unique) var name: String
    var name: String
    var date: Date
    var value: Double
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}
