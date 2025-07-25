//
//  AITool.swift
//  AICommandBar
//
//  Created by Chance Martinez on 7/25/25.
//


import Foundation

enum AITool: String, CaseIterable {
    case createCustomer
    case readCustomers
    case updateCustomer
    case deleteCustomer
    case deleteAllCustomers

    var definition: [String: Any] {
        switch self {
        case .createCustomer:
            return [
                "type": "function",
                "function": [
                    "name": self.rawValue,
                    "description": "Create a new customer with a name and email.",
                    "parameters": [
                        "type": "object",
                        "properties": [
                            "name": ["type": "string", "description": "Customer's full name"],
                            "email": ["type": "string", "description": "Customer's email"]
                        ],
                        "required": ["name", "email"]
                    ]
                ]
            ]

        case .readCustomers:
            return [
                "type": "function",
                "function": [
                    "name": self.rawValue,
                    "description": "Read or list all customers.",
                    "parameters": [
                        "type": "object",
                        "properties": [:] // No input needed for now
                    ]
                ]
            ]

        case .updateCustomer:
            return [
                "type": "function",
                "function": [
                    "name": self.rawValue,
                    "description": "Update an existing customer's email.",
                    "parameters": [
                        "type": "object",
                        "properties": [
                            "name": ["type": "string"],
                            "newEmail": ["type": "string"]
                        ],
                        "required": ["name", "newEmail"]
                    ]
                ]
            ]

        case .deleteCustomer:
            return [
                "type": "function",
                "function": [
                    "name": self.rawValue,
                    "description": "Delete a customer by name.",
                    "parameters": [
                        "type": "object",
                        "properties": [
                            "name": ["type": "string"]
                        ],
                        "required": ["name"]
                    ]
                ]
            ]

        case .deleteAllCustomers:
            return [
                "type": "function",
                "function": [
                    "name": self.rawValue,
                    "description": "Delete all customers from the database. Use only when the user asks to remove, delete, or clear all customers.",
                    "parameters": [
                        "type": "object",
                        "properties": [
                            "name": ["type": "string"]
                        ],
                        "required": ["name"]
                    ]
                ]
            ]
        }
    }
}
