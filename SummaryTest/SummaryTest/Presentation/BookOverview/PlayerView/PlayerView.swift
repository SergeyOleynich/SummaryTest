//
//  PlayerView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

import Colors
import ComposableArchitecture

struct PlayerView: View {
    @Binding var seekWidth: CGFloat
    
    let store: StoreOf<PlayerViewDomain>
    
    init(store: StoreOf<PlayerViewDomain>, seekWidth: Binding<CGFloat> = .constant(290)) {
        self.store = store
        self._seekWidth = seekWidth
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 16.0) {
                VStack(alignment: .center, spacing: 8.0) {
                    Text(viewStore.itemTitle)
                        .font(.system(.headline))
                        .foregroundColor(Color._999592)
                    
                    Text(viewStore.itemDescription)
                        .font(.system(.subheadline))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .foregroundColor(.black)
                }
                .frame(width: seekWidth)
                
                PlayerTimeProgressView(
                    store: store.scope(
                        state: \.progressViewState,
                        action: { .progressViewAction(action: $0) }),
                    seekWidth: $seekWidth)
                
                Button(viewStore.rate.title) {
                    viewStore.send(.speedButtonTapped)
                }
                .buttonStyle(SpeedButtonStyle())
            }
        }
    }
}

// MARK: - Constans

private extension PlayerView {
    enum Constants {
        static let knobSize = CGSize(width: 25, height: 25)
        static let seekHeight = 6.0
    }
}

// MARK: - Preview

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(store: Store(initialState: PlayerViewDomain.State()) { PlayerViewDomain() })
    }
}
