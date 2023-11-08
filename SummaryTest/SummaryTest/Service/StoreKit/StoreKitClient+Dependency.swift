//
//  StoreKitClient+Dependency.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation
import Dependencies

// MARK: - DependencyKey

extension StoreKitClient: DependencyKey {
    static var liveValue: StoreKitClient = {
        let storeKit = StoreKitActor()
        
        return StoreKitClient(
            product: { try await storeKit.product() },
            purchase: { try await storeKit.purchase($0) })
    }()
    
    static var testValue: StoreKitClient {
        preconditionFailure()
    }
}

// MARK: - DependencyValues

extension DependencyValues {
    var storeKit: StoreKitClient {
        get { self[StoreKitClient.self] }
        set { self[StoreKitClient.self] = newValue }
    }
}
