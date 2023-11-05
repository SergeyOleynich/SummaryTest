//
//  PlayerControlsView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

import ComposableArchitecture

struct PlayerControlsView: View {
    let store: StoreOf<PlayerControlDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "backward.end.fill")
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "gobackward.5")
                        .frame(maxWidth: .infinity)
                }
                .scaleEffect(1.5)
                
                Button {
                    if viewStore.state.isPlaying {
                        viewStore.send(.pauseButtonTapped)
                    }
                    else {
                        viewStore.send(.playButtonTapped)
                    }
                } label: {
                    Image(systemName: viewStore.state.isPlaying ? "pause.fill" : "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .scaleEffect(1.8)
                
                Button {
                    
                } label: {
                    Image(systemName: "goforward.10")
                        .frame(maxWidth: .infinity)
                }
                .scaleEffect(1.5)
                
                Button {
                    
                } label: {
                    Image(systemName: "forward.end.fill")
                        .frame(maxWidth: .infinity)
                }
            }
            .font(.system(size: 20))
            .foregroundColor(.black)
        }
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView(
            store: Store(initialState: PlayerControlDomain.State()) {
                PlayerControlDomain()
            })
    }
}
