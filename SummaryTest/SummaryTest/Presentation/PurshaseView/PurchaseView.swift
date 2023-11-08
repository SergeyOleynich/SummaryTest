//
//  PurchaseView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

import Colors
import ComposableArchitecture

struct PurchaseView: View {
    let store: StoreOf<PurchaseViewDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16.0) {
                VStack(spacing: 8.0) {
                    Text("Unlock learning")
                        .font(.system(.largeTitle))
                        .foregroundColor(.black)
                    
                    Text("Grow on the go by listening and reading the world's best ideas")
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .font(.system(.headline))
                        .foregroundColor(.black)
                }
                
                Button("Start Listening - \(viewStore.formattedPrice)") {
                    viewStore.send(.purchasedButtonTapped, animation: .easeIn(duration: 0.3))
                }
                .buttonStyle(PurchaseButtonStyle())
            }
            .padding()
        }
    }
}

// MARK: - Preview

#if DEBUG
struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        let item = BookItem(
            id: "1",
            title: "Title",
            image: Image(systemName: "pencil"),
            price: 89.99,
            keyPoints: [])
    
        PurchaseView(store: Store(initialState: PurchaseViewDomain.State(item: item)) { PurchaseViewDomain() })
    }
}
#endif
