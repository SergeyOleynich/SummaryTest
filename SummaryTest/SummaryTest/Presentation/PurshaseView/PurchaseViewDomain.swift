//
//  PurchaseViewDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import SwiftUI

import ComposableArchitecture

struct PurchaseViewDomain: Reducer {
    struct State: Equatable {
        let price: Double = 89.99
    }
    
    enum Action {
        case purchasedButtonTapped
    }
    
    var body: some ReducerOf<PurchaseViewDomain> {
        Reduce { state, action in
            switch action {
            case .purchasedButtonTapped:
                return .none
            }
        }
    }
}

// MARK: - State Computed Properties

extension PurchaseViewDomain.State {
    var formattedPrice: String {
        price
            .formatted(
                .currency(code: "USD")
                .locale(Locale(identifier: "en_US_POSIX")))
    }
}
