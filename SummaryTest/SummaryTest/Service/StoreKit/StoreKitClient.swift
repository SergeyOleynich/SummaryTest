//
//  StoreKitClient.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation

// MARK: - StoreKitError

enum StoreKitError: Error {
    case failedVerification
}

// MARK: - StoreKitClient

struct StoreKitClient {
    var product: () async throws -> BookItem?
    var purchase: (BookItem) async throws -> Bool
}
