//
//  PlayerControlDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

import ComposableArchitecture

struct PlayerControlDomain: Reducer {
    struct State: Equatable {
        var isPlaying = false
    }
    
    enum Action {
        case playButtonTapped
        case pauseButtonTapped
        case backwardButtonTapped
        case forwardButtonTapped
        case goBackwardButtonTapped
        case goForwardButtonTapped
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .playButtonTapped:
            if state.isPlaying == false {
                state.isPlaying.toggle()
            }
            return .none
            
        case .pauseButtonTapped:
            if state.isPlaying {
                state.isPlaying.toggle()
            }
            
            return .none
            
        case .backwardButtonTapped:
            return .none
            
        case .forwardButtonTapped:
            return .none
            
        case .goBackwardButtonTapped:
            return .none
            
        case .goForwardButtonTapped:
            return .none
        }
    }
}
