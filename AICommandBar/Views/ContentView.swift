//
//  ContentView.swift
//  AICommandBar
//
//  Created by Chance Martinez on 7/25/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var customers: [Customer]

    var body: some View {
        FloatingSearchBarView()
    }
}
