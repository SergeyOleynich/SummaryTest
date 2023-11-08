//
//  PlayerTimeProgressView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

import Colors
import ComposableArchitecture

struct PlayerTimeProgressView: View {
    @Binding var seekWidth: CGFloat
    
    let store: StoreOf<PlayerTimeProgressDomain>
    
    init(store: StoreOf<PlayerTimeProgressDomain>, seekWidth: Binding<CGFloat> = .constant(0.0)) {
        self.store = store
        self._seekWidth = seekWidth
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Text(viewStore.currentTimeInterval.playerValueRepresentation)
                    .font(.callout.monospacedDigit())
                
                PlayerProgressView(
                    store: store.scope(state: \.playerProgressState, action: { .playerProgressAction(action: $0) }))
                    .knobSize(Constants.knobSize)
                    .seekHeight(Constants.seekHeight)
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(
                                    key: WidthPreferenceKey.self,
                                    value: [proxy.size.width])
                        }
                    )
                
                Text(viewStore.maxTimeInterval.playerValueRepresentation)
                    .font(.callout.monospacedDigit())
            }
            .foregroundColor(Color._999592)
            .onPreferenceChange(WidthPreferenceKey.self) { preference in
                seekWidth = preference.first ?? .zero
            }
        }
    }
}

// MARK: - Constans

private extension PlayerTimeProgressView {
    enum Constants {
        static let knobSize = CGSize(width: 25, height: 25)
        static let seekHeight = 6.0
    }
}

// MARK: - Preview

#if DEBUG
struct PlayerTimeProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let state = PlayerTimeProgressDomain.State(
            currentTimeInterval: 0.0,
            maxTimeInterval: 60)
        
        PlayerTimeProgressView(
            store: Store(initialState: state) { PlayerTimeProgressDomain() })
    }
}
#endif
