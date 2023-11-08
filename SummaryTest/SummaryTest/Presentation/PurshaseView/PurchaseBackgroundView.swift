//
//  PurchaseBackgroundView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

struct PurchaseBackgroundView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: .white, location: 0.3)
            ],
            startPoint: .top,
            endPoint: .bottom)
        .overlay(content())
    }
}

// MARK: - Preview

#if DEBUG
struct PurchaseBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseBackgroundView {
            Text("Test")
        }
    }
}
#endif
