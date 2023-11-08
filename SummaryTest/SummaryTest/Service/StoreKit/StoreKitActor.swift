//
//  StoreKitActor.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation
import StoreKit

actor StoreKitActor {
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
}

// MARK: - Private

private extension StoreKitActor {
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreKitError.failedVerification
        case .verified(let safe): return safe
        }
    }
}
