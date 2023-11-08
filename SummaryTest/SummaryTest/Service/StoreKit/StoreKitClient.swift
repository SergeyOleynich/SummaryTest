//
//  StoreKitClient.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation

import Dependencies
import StoreKit

// MARK: - StoreKitError

enum StoreKitError: Error {
    case failedVerification
}

// MARK: - StoreKitClient

struct StoreKitClient {
    var product: () async throws -> Product?
    var purchase: (Product) async throws -> Transaction?
}

// MARK: - StoreKitActor

private actor StoreKitActor {
    func product() async throws -> Product? {
        try await Product.products(for: ["osa.SummaryTest.Atomic"]).first
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        
        default:
            return nil
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreKitError.failedVerification
        case .verified(let safe): return safe
        }
    }
}

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
