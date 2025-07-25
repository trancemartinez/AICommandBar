//
//  AISearchHandler.swift
//  AICommandBar
//
//  Created by Chance Martinez on 7/25/25.
//
import Foundation
import SwiftData


class AISearchHandler {
    let provider: AIProvider
    let modelContext: ModelContext


    init(provider: AIProvider, modelContext: ModelContext) {
        self.provider = provider
        self.modelContext = modelContext
    }

    func search(query: String, completion: @escaping (Result<String, Error>) -> Void) {
        switch provider {
        case .openAI(let apiKey):
            guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return }

            let messages: [[String: Any]] = [
                ["role": "user", "content": query]
            ]

            let payload: [String: Any] = [
                "model": "gpt-4o",
                "messages": messages,
                "tools": ToolRegistry.tools,
                "tool_choice": "auto"
            ]

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    return completion(.failure(error))
                }

                guard let data = data else {
                    return completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                }

                do {
                    print("🧠 OpenAI Response:", String(data: data, encoding: .utf8) ?? "")

                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    guard let choices = json?["choices"] as? [[String: Any]],
                          let first = choices.first,
                          let message = first["message"] as? [String: Any] else {
                        return completion(.failure(NSError(domain: "", code: -2, userInfo: nil)))
                    }

                    if let toolCalls = message["tool_calls"] as? [[String: Any]] {
                        let toolCallData = try JSONSerialization.data(withJSONObject: toolCalls[0])
                        let toolCall = try JSONDecoder().decode(ToolCall.self, from: toolCallData)

                        let handler = ToolResponseHandler(modelContext: self.modelContext)

                        do {
                            try handler.handle(toolCall: toolCall)
                            return completion(.success("✅ Tool executed: \(toolCall.function.name)"))
                        } catch {
                            return completion(.failure(error))
                        }
                    }

                    // 📝 If no tool, return regular content
                    if let content = message["content"] as? String {
                        return completion(.success(content))
                    }

                    return completion(.failure(NSError(domain: "", code: -3, userInfo: nil)))

                } catch {
                    return completion(.failure(error))
                }

            }.resume()

        case .appleBuiltIn:
            completion(.success("Apple Intelligence not yet implemented."))
        }
    }

}
