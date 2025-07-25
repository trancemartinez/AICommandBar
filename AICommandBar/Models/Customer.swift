//
//  Item.swift
//  AICommandBar
//
//  Created by Chance Martinez on 7/25/25.
//

import Foundation
import SwiftData

@Model
class Customer {
    var name: String
    var email: String
    var timestamp: Date

    init(name: String, email: String, timestamp: Date) {
        self.name = name
        self.email = email
        self.timestamp = timestamp
    }
}
