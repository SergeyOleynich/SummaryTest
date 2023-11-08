//
//  StoreKitClient.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation

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
