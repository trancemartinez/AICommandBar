//
//  CommandError.swift
//  AICommandBar
//
//  Created by Chance Martinez on 7/25/25.
//


import Foundation
import SwiftData

enum CommandError: Error {
    case unknownTool
    case invalidArguments
    case executionFailed
}

class ToolResponseHandler {
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func handle(toolCall: ToolCall) throws {
        guard let tool = AITool(rawValue: toolCall.function.name) else {
            throw CommandError.unknownTool
        }

        // Decode arguments JSON string to Dictionary
        guard let argsData = toolCall.function.arguments.data(using: .utf8),
              let args = try? JSONSerialization.jsonObject(with: argsData) as? [String: Any] else {
            throw CommandError.invalidArguments
        }

        switch tool {
        case .createCustomer:
            guard let name = args["name"] as? String,
                  let email = args["email"] as? String else {
                throw CommandError.invalidArguments
            }
            let customer = Customer(name: name, email: email, timestamp: .now)
            modelContext.insert(customer)
            try modelContext.save()

        case .readCustomers:
            let fetchDescriptor = FetchDescriptor<Customer>()
            let results = try modelContext.fetch(fetchDescriptor)
            print("📋 Customers: \(results.map { $0.name })")

        case .updateCustomer:
            guard let name = args["name"] as? String,
                  let newEmail = args["newEmail"] as? String else {
                throw CommandError.invalidArguments
            }

            let descriptor = FetchDescriptor<Customer>(predicate: #Predicate { $0.name == name })
            if let customer = try modelContext.fetch(descriptor).first {
                customer.email = newEmail
                try modelContext.save()
            } else {
                print("⚠️ No customer found with name \(name)")
            }

        case .deleteCustomer:
            guard let name = args["name"] as? String else {
                throw CommandError.invalidArguments
            }

            let descriptor = FetchDescriptor<Customer>(predicate: #Predicate { $0.name == name })
            let customers = try modelContext.fetch(descriptor)
            for customer in customers {
                modelContext.delete(customer)
            }
            try modelContext.save()
        
        case .deleteAllCustomers:
            let fetchDescriptor = FetchDescriptor<Customer>()
            let customers = try modelContext.fetch(fetchDescriptor)
            for customer in customers {
                modelContext.delete(customer)
            }
            try modelContext.save()
        }
    }
}
