//
//  Collection+Extension.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? { indices.contains(index) ? self[index] : nil }
}
