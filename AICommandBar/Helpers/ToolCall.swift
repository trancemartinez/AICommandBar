//
//  ToolCall.swift
//  AICommandBar
//
//  Created by Chance Martinez on 7/25/25.
//


import Foundation

struct ToolCall: Decodable {
    struct Function: Decodable {
        let name: String
        let arguments: String // JSON string
    }

    let id: String
    let function: Function
}
