//
//  PlayerTimeProgressDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import SwiftUI

import ComposableArchitecture

extension DateComponentsFormatter {
    static let playerComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
}

struct PlayerTimeProgressDomain: Reducer {
    struct State: Equatable {
        var currentTimeInterval: TimeInterval? = nil
        var maxTimeInterval: TimeInterval? = nil
        
        var playerProgressState: PlayerProgressDomain.State = .init(currentTimeInterval: 0.0)
    }
    
    enum Action {
        case playerProgressAction(action: PlayerProgressDomain.Action)
    }
    
    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

extension Optional where Wrapped == TimeInterval {
    var playerValueRepresentation: String {
        guard let timeInterval = self else { return "--:--" }
        
        return DateComponentsFormatter.playerComponentsFormatter.string(from: timeInterval) ?? "--:--"
    }
}
