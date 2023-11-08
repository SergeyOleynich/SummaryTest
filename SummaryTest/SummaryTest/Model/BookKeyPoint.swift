//
//  BookKeyPoint.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation

struct BookKeyPoint {
    let id: Int
    
    let url: URL
    let description: String
}

// MARK: - Equatable

extension BookKeyPoint: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
