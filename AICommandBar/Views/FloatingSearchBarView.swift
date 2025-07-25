//
//  FloatingSearchBarView.swift
//  AICommandBar
//
//  Created by Chance Martinez on 7/25/25.
//

import SwiftUI
import SwiftData

struct FloatingSearchBarView: View {
    @State private var searchText = ""
    @State private var aiResponse: String = ""
    @State private var isLoading = false
    @Environment(\.modelContext) private var modelContext: ModelContext

    // Hardcoded AI provider for now
    private var handler: AISearchHandler {
        AISearchHandler(
            provider: .openAI(apiKey: "nope"),
            modelContext: modelContext
        )
    }
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 16) {
                    if isLoading {
                        ProgressView()
                            .padding()
                    } else if !aiResponse.isEmpty {
                        Text(aiResponse)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                    }

//                    ForEach(0..<50, id: \.self) { idx in
//                        Text("Item \(idx)")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color(.secondarySystemBackground))
//                            .cornerRadius(12)
//                            .padding(.horizontal, 20)
//                    } replace with view of customers
                }
                .padding(.top, topSpacing + barHeight)
            }

            HStack {
                TextField("", text: $searchText, onCommit: performSearch)
                    .foregroundColor(.primary)
                    .submitLabel(.search)

                Image(systemName:"magnifyingglass")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .frame(height: barHeight)
            .padding(.top, topSpacing)
            .zIndex(100)
        }
        .ignoresSafeArea(.keyboard)
    }

    private func performSearch() {
        guard !searchText.isEmpty else { return }
        isLoading = true
        aiResponse = ""
        handler.search(query: searchText) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let reply):
                    aiResponse = reply
                case .failure(let error):
                    aiResponse = "Error: \(error.localizedDescription)"
                }
            }
        }
    }

    private var topSpacing: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
            .first ?? 44
    }

    private var barHeight: CGFloat { 56 }
}
