//
//  AIProvider.swift
//  AICommandBar
//
//  Created by Chance Martinez on 7/25/25.
//


enum AIProvider {
    case openAI(apiKey: String)
    case appleBuiltIn // placeholder for future use

    var name: String {
        switch self {
        case .openAI: return "OpenAI"
        case .appleBuiltIn: return "Apple Intelligence"
        }
    }
}