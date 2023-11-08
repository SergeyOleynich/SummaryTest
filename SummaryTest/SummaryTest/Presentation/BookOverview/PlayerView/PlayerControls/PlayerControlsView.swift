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
            HStack(spacing: .zero) {
                backwardView { viewStore.send($0) }
                    .padding([.top, .bottom], 8)
                    .foregroundColor(viewStore.isBackwardActive ? Constants.activeColor : Constants.disableColor)
                    .disabled(!viewStore.isBackwardActive)
                
                goBackwardView { viewStore.send($0) }
                    .padding([.top, .bottom], 4)
                    .disabled(!viewStore.isActive)
                
                if viewStore.isPlaying {
                    pauseView { viewStore.send($0) }
                }
                else {
                    playView { viewStore.send($0) }
                        .disabled(!viewStore.isActive)
                }
                
                goForwardView { viewStore.send($0) }
                    .padding([.top, .bottom], 4)
                    .disabled(!viewStore.isActive)
                
                forwardView { viewStore.send($0) }
                    .padding([.top, .bottom], 8)
                    .foregroundColor(viewStore.isForwardActive ? Constants.activeColor : Constants.disableColor)
                    .disabled(!viewStore.isForwardActive)
            }
            .foregroundColor(viewStore.isActive ? Constants.activeColor : Constants.disableColor)
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
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
    
    func goBackwardView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.goBackwardButtonTapped)
        } label: {
            Image(systemName: "gobackward.5")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
    
    func playView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.playButtonTapped)
        } label: {
            Image(systemName: "play.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
    
    func pauseView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.pauseButtonTapped)
        } label: {
            Image(systemName: "pause.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
    
    func goForwardView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.goForwardButtonTapped)
        } label: {
            Image(systemName: "goforward.10")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
    
    func forwardView(_ action: @escaping (PlayerControlDomain.Action) -> Void) -> some View {
        return Button {
            action(.forwardButtonTapped)
        } label: {
            Image(systemName: "forward.end.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Constants

private extension PlayerControlsView {
    enum Constants {
        static let activeColor = Color.black
        static let disableColor = Color.black.opacity(0.5)
    }
}

// MARK: - Preview

#if DEBUG
struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView(
            store: Store(initialState: PlayerControlDomain.State()) {
                PlayerControlDomain()
            })
    }
}
#endif
