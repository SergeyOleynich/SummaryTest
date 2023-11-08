//
//  AudioPlayerClient.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import Foundation

import Dependencies
import AVFoundation

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

// MARK: - AudioActor

fileprivate actor AudioActor {
    private weak var audioDelegate: AudioDelegate?
    private var audioPlayer: AVAudioPlayer?
    
    var duration: TimeInterval { audioPlayer?.duration ?? 0.0 }
    var currentTimeInterval: TimeInterval { audioPlayer?.currentTime ?? 0.0 }
    
    init(audioDelegate: AudioDelegate? = nil, audioPlayer: AVAudioPlayer? = nil) {
        self.audioDelegate = audioDelegate
        self.audioPlayer = audioPlayer
    }
    
    func load(url: URL) throws -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        
        if audioSession.category != .playback {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        
        let audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer.enableRate = true
        audioPlayer.delegate = audioDelegate
        
        self.audioPlayer = audioPlayer
        
        return audioPlayer.prepareToPlay()
    }
    
    func play() throws -> Bool {
        return audioPlayer?.play() ?? false
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func setRate(rate: Float) {
        audioPlayer?.rate = rate
    }
    
    func advancedTimeInterval(_ timeInterval: TimeInterval) {
        guard timeInterval.isZero == false,
                timeInterval.isNaN == false,
                let currentTime = audioPlayer?.currentTime else { return }
        
        audioPlayer?.currentTime = currentTime + timeInterval
    }
}

// MARK: - AudioDelegate

private final class AudioDelegate: NSObject, AVAudioPlayerDelegate {
    var playerDidFinishPlaying: ((_ player: AVAudioPlayer, _ successfully: Bool) -> Void)? = nil
    var playerDecodeErrorDidOccur: ((_ player: AVAudioPlayer, _ error: Error?) -> Void)? = nil
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerDidFinishPlaying?(player, flag)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        playerDecodeErrorDidOccur?(player, error)
    }
}

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
