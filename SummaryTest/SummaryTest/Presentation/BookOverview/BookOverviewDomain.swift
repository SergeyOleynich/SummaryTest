//
//  BookOverviewDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import SwiftUI

import ComposableArchitecture

struct BookOverviewDomain: Reducer {
    struct State: Equatable {
        var choice: Choice = .listening
        
        var purchaseState: PurchaseViewDomain.State? = PurchaseViewDomain.State()
    }
    
    enum Action {
        case purchaseViewAction(action: PurchaseViewDomain.Action)
        
        case choiceToggleTapped
    }
    
    enum Choice {
        case listening
        case reading
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .purchaseViewAction(let action):
                print(#function, action)
                state.purchaseState = nil
                return .none
                
            case .choiceToggleTapped where state.choice == .listening:
                state.choice = .reading
                return .none
            
            case .choiceToggleTapped where state.choice == .reading:
                state.choice = .listening
                return .none
                
            case .choiceToggleTapped:
                return .none
            }
        }
        .ifLet(\.purchaseState, action: /Action.purchaseViewAction) {
            PurchaseViewDomain()
        }
    }
}
