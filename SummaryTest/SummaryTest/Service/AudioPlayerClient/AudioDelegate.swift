//
//  AudioDelegate.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 08.11.2023.
//

import Foundation
import AVFoundation

final class AudioDelegate: NSObject {
    var playerDidFinishPlaying: ((_ player: AVAudioPlayer, _ successfully: Bool) -> Void)? = nil
    var playerDecodeErrorDidOccur: ((_ player: AVAudioPlayer, _ error: Error?) -> Void)? = nil
}

// MARK: - AVAudioPlayerDelegate

extension AudioDelegate: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerDidFinishPlaying?(player, flag)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        playerDecodeErrorDidOccur?(player, error)
    }
}
