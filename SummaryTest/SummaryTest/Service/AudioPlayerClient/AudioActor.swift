//
//  AudioActor.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation
import AVFoundation

actor AudioActor {
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
