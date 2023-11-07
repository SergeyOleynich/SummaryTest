//
//  BookOverviewDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import SwiftUI

import ComposableArchitecture
import AVFoundation

struct BookOverviewDomain: Reducer {
    struct State: Equatable {
        var choice: Choice = .listening
        var isStartPurchasing: Bool = false
        
        var purchaseState: PurchaseViewDomain.State? = PurchaseViewDomain.State()
        var playerState: PlayerViewDomain.State = .init()
        var playerControlState = PlayerControlDomain.State()
    }
    
    enum Action {
        case purchaseViewAction(action: PurchaseViewDomain.Action)
        case playerViewAction(action: PlayerViewDomain.Action)
        case playerControlAction(action: PlayerControlDomain.Action)

        case purchaseFinished
        case choiceToggleTapped
    }
    
    enum Choice {
        case listening
        case reading
    }
        
    var body: some ReducerOf<Self> {
        Scope(state: \.playerState, action: /Action.playerViewAction) { PlayerViewDomain() }
        Scope(state: \.playerControlState, action: /Action.playerControlAction) { PlayerControlDomain() }

        Reduce { state, action in
            switch action {
            case .purchaseViewAction(.purchasedButtonTapped):
                state.isStartPurchasing = true
                
                return .run { send in
                    try await Task.sleep(nanoseconds: 2_000_000_000)
                    
                    await send(.purchaseFinished)
                }
                
            case .purchaseViewAction:
                return .none
                
            case let .playerViewAction(.didLoadItemUrl(success)) where success == true:
                state.playerControlState.isActive.toggle()
                return .none
            
            case .playerViewAction:
                return .none
                
            case .playerControlAction(.playButtonTapped):
                return .send(.playerViewAction(action: .didStartPlaying))
            
            case .playerControlAction(.pauseButtonTapped):
                return .send(.playerViewAction(action: .didPausePlaying))
            
            case .playerControlAction(.goBackwardButtonTapped):
                return .send(.playerViewAction(action: .didGoBackward))
                
            case .playerControlAction(.goForwardButtonTapped):
                return .send(.playerViewAction(action: .didGoForward))
                
            case .playerControlAction:
                return .none

            case .choiceToggleTapped where state.choice == .listening:
                state.choice = .reading
                return .none
            
            case .choiceToggleTapped where state.choice == .reading:
                state.choice = .listening
                return .none
                
            case .choiceToggleTapped:
                return .none
                
            case .purchaseFinished:
                state.purchaseState = nil
                let itemUrl = Bundle.main.url(forResource: "Summary_of_Atomic_Habits", withExtension: "mp3")!
                
                return .send(.playerViewAction(action: .didReceiveItemUrl(itemUrl: itemUrl)))
            }
        }
        
        .ifLet(\.purchaseState, action: /Action.purchaseViewAction) {
            PurchaseViewDomain()
        }
    }
}
