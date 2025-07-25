//
//  ToolRegistry.swift
//  AICommandBar
//
//  Created by Chance Martinez on 7/25/25.
//

struct ToolRegistry {
    static var tools: [[String: Any]] {
        AITool.allCases.map { $0.definition }
    }
}
