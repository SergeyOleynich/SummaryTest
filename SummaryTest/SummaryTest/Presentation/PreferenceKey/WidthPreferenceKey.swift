//
//  WidthPreferenceKey.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

struct WidthPreferenceKey: PreferenceKey {
    /// It is some bug for me that in Canvas just CGFloat doesnt work. wrapped it inside Array - works.
    static var defaultValue: [CGFloat] = []

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
