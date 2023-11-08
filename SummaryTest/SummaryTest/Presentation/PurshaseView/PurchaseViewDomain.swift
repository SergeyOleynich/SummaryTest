//
//  PurchaseViewDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import SwiftUI

import ComposableArchitecture
import StoreKit

struct PurchaseViewDomain: Reducer {
    struct State: Equatable {
        let product: Product
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
        product
            .price
            .formatted(
                .currency(code: "USD")
                .locale(Locale(identifier: "en_US_POSIX")))
    }
}
