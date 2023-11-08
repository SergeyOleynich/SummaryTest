//
//  SummaryTestApp.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

import ComposableArchitecture

@main
struct SummaryTestApp: App {
    @State private var store = Store(initialState: BookOverviewDomain.State()) {
        BookOverviewDomain()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            BookOverviewView(store: store)
        }
    }
}
