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
                backwardView { viewStore.send($0) }
                
                goBackwardView { viewStore.send($0) }
                    .scaleEffect(1.5)

                Group {
                    if viewStore.isPlaying {
                        pauseView { viewStore.send($0) }
                    }
                    else {
                        playView { viewStore.send($0) }
                    }
                }
                .scaleEffect(1.8)

                goForwardView { viewStore.send($0) }
                    .scaleEffect(1.5)

                forwardView { viewStore.send($0) }
            }
            .font(.system(size: 20))
            .foregroundColor(.black)
        }
    }
}

// MARK: - ViewBuilders

private extension PlayerControlsView {
    func backwardView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.backwardButtonTapped)
        } label: {
            Image(systemName: "backward.end.fill")
                .frame(maxWidth: .infinity)
        }
    }
    
    func goBackwardView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.goBackwardButtonTapped)
        } label: {
            Image(systemName: "gobackward.5")
                .frame(maxWidth: .infinity)
        }
    }
    
    func playView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.playButtonTapped)
        } label: {
            Image(systemName: "play.fill")
                .frame(maxWidth: .infinity)
        }
    }
    
    func pauseView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.pauseButtonTapped)
        } label: {
            Image(systemName: "pause.fill")
                .frame(maxWidth: .infinity)
        }
    }
    
    func goForwardView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.goForwardButtonTapped)
        } label: {
            Image(systemName: "goforward.10")
                .frame(maxWidth: .infinity)
        }
    }
    
    func forwardView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.forwardButtonTapped)
        } label: {
            Image(systemName: "forward.end.fill")
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView(
            store: Store(initialState: PlayerControlDomain.State()) {
                PlayerControlDomain()
            })
    }
}
