//
//  AudioPlayerClient+Dependency.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation

import Dependencies

// MARK: - DependencyKey

extension AudioPlayerClient: DependencyKey {
    static var liveValue: AudioPlayerClient = {
        let audioDelegate = AudioDelegate()
        let audioActor = AudioActor(audioDelegate: audioDelegate)
        
        return AudioPlayerClient(
            load: { try await audioActor.load(url: $0) },
            play: { try await audioActor.play() },
            pause: { await audioActor.pause() },
            setRate: { await audioActor.setRate(rate: $0) },
            advancedTime: { await audioActor.advancedTimeInterval($0) },
            observe: {
                let stream = AsyncThrowingStream<Bool, Error> { continuation in
                    audioDelegate.playerDidFinishPlaying = { _, flag in
                        continuation.yield(with: .success(flag))
                    }
                    audioDelegate.playerDecodeErrorDidOccur = { _, error in
                        continuation.finish(throwing: error)
                    }
                }
                
                return stream
            },
            currentTimeInterval: { await audioActor.currentTimeInterval },
            maxDuration: { await audioActor.duration })
    }()
    
    static var testValue: AudioPlayerClient {
        preconditionFailure()
    }
}

// MARK: - DependencyValues

extension DependencyValues {
    var audioPlayer: AudioPlayerClient {
        get { self[AudioPlayerClient.self] }
        set { self[AudioPlayerClient.self] = newValue }
    }
}
