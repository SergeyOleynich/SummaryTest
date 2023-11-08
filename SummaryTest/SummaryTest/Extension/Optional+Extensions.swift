//
//  Optional+Extensions.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation

extension Optional where Wrapped == TimeInterval {
    var playerValueRepresentation: String {
        guard let timeInterval = self else { return "--:--" }
        
        return DateComponentsFormatter.playerComponentsFormatter.string(from: timeInterval) ?? "--:--"
    }
}
