//
//  AudioPlayerClient.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import Foundation

import Dependencies
import AVFoundation

struct AudioPlayerClient {
    var load: (_ url: URL) async throws -> Bool
    var play: () async throws -> Bool
    var pause: () async -> Void
    var setRate: (_ rate: Float) async -> Void
    var advancedTime: (_ timeInterval: TimeInterval) async -> Void
    
    var currentTimeInterval: () async -> TimeInterval
    var maxDuration: () async -> TimeInterval
}

fileprivate actor AudioActor {
    private var audioPlayer: AVAudioPlayer?
    
    var duration: TimeInterval { audioPlayer?.duration ?? 0.0 }
    var currentTimeInterval: TimeInterval { audioPlayer?.currentTime ?? 0.0 }
    
    func load(url: URL) throws -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        
        if audioSession.category != .playback {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        
        let audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer.enableRate = true
        
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

// MARK: - DependencyKey

extension AudioPlayerClient: DependencyKey {
    static var liveValue: AudioPlayerClient = {
        let audioActor = AudioActor()
        
        return AudioPlayerClient(
            load: { try await audioActor.load(url: $0) },
            play: { try await audioActor.play() },
            pause: { await audioActor.pause() },
            setRate: { await audioActor.setRate(rate: $0) },
            advancedTime: { await audioActor.advancedTimeInterval($0) },
            currentTimeInterval: { await audioActor.currentTimeInterval },
            maxDuration: { await audioActor.duration })
    }()
    
    static var testValue: AudioPlayerClient {
        preconditionFailure()
    }
}

extension DependencyValues {
    var audioPlayer: AudioPlayerClient {
        get { self[AudioPlayerClient.self] }
        set { self[AudioPlayerClient.self] = newValue }
    }
}


//
//private final class Delegate: NSObject, AVAudioPlayerDelegate, Sendable {
//    let didFinishPlaying: @Sendable (Bool) -> Void
//    let decodeErrorDidOccur: @Sendable (Error?) -> Void
//    let player: AVAudioPlayer
//
//    init(
//        url: URL,
//        didFinishPlaying: @escaping @Sendable (Bool) -> Void,
//        decodeErrorDidOccur: @escaping @Sendable (Error?) -> Void
//    ) throws {
//        self.didFinishPlaying = didFinishPlaying
//        self.decodeErrorDidOccur = decodeErrorDidOccur
//        self.player = try AVAudioPlayer(contentsOf: url)
//        super.init()
//        self.player.delegate = self
//    }
//
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        self.didFinishPlaying(flag)
//    }
//
//    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
//        self.decodeErrorDidOccur(error)
//    }
//}
