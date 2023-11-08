//
//  AudioPlayerClient.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import Foundation

import Dependencies

// MARK: - AudioPlayerClient

struct AudioPlayerClient {
    var load: (_ url: URL) async throws -> Bool
    var play: () async throws -> Bool
    var pause: () async -> Void
    var setRate: (_ rate: Float) async -> Void
    var advancedTime: (_ timeInterval: TimeInterval) async -> Void
    
    var observe: () -> AsyncThrowingStream<Bool, Error>
    
    var currentTimeInterval: () async -> TimeInterval
    var maxDuration: () async -> TimeInterval
}
