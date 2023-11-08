//
//  BookItem.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation
import SwiftUI

struct BookItem {
    let id: String
    
    let title: String
    let image: Image
    
    let price: Decimal
    let keyPoints: [BookKeyPoint]
}

// MARK: - Equatable

extension BookItem: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
