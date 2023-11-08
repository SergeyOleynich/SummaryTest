//
//  StoreKitActor.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation
import StoreKit
import SwiftUI

actor StoreKitActor {
    private var products: [Product] = []
    
    func product() async throws -> BookItem? {
        guard let product = try await Product.products(for: ["osa.SummaryTest.Atomic"]).first else { return nil }
        
        guard let firstItemUrl = Bundle.main.url(forResource: "Summary_of_Atomic_Habits", withExtension: "mp3") else { return nil }
        guard let secondItemUrl = Bundle.main.url(forResource: "Summary_of_Rich_Dad", withExtension: "mp3") else { return nil }
        
        products.append(product)
        
        return BookItem(
            id: product.id,
            title: product.displayName,
            image: Image("AtomicHabits"),
            price: product.price,
            keyPoints: [
                BookKeyPoint(
                    id: 1,
                    url: firstItemUrl,
                    description: "Design is not how thing looks, but how it works"),
                BookKeyPoint(
                    id: 2,
                    url: secondItemUrl,
                    description: "I decided to revert to the previous version")
            ]
        )
    }
    
    func purchase(_ item: BookItem) async throws -> Bool {
        guard let product = products.first(where: { $0.id == item.id }) else { return false }
        
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            return true
        case .userCancelled, .pending:
            return false
        
        default:
            return false
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
