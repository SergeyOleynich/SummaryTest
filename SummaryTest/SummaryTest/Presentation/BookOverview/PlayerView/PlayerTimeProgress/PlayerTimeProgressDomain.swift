//
//  PlayerTimeProgressDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import SwiftUI

import ComposableArchitecture

struct PlayerTimeProgressDomain: Reducer {
    struct State: Equatable {
        var currentTimeInterval: TimeInterval? = 0.0
        var maxTimeInterval: TimeInterval? = 0.0
        
        var playerProgressState: PlayerProgressDomain.State = .init(currentTimeInterval: 0.0)
    }
    
    enum Action {
        case playerProgressAction(action: PlayerProgressDomain.Action)
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
