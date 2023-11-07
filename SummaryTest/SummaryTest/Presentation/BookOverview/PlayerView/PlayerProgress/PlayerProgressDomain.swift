//
//  PlayerProgressDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import Foundation

import ComposableArchitecture

struct PlayerProgressDomain: Reducer {
    struct State: Equatable {
        var currentTimeInterval: TimeInterval = 0.0 {
            didSet {
                progress = currentTimeInterval / maxTimeInterval
            }
        }
        
        var maxTimeInterval: TimeInterval = .greatestFiniteMagnitude
        
        var progress: Double = 0.0
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
