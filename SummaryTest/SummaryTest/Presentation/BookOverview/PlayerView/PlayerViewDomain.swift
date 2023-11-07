//
//  PlayerViewDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import SwiftUI

import ComposableArchitecture

struct PlayerViewDomain: Reducer {
    struct State: Equatable {
        let itemTitle: String = "KEY POINT 2 OF 10"
        let itemDescription: String = "Design is not how thing looks, but how it works"
        
        var rate: Rate = .normal
        
        var progressViewState: PlayerTimeProgressDomain.State = .init()
    }
    
    enum Action {
        case progressViewAction(action: PlayerTimeProgressDomain.Action)
        
        case didReceiveItemUrl(itemUrl: URL)
        case didLoadItemUrl(success: Bool)
        case didFailedToLoadItem(error: Error)
        case didReceiveItemDuration(duration: TimeInterval)
        case didStartPlaying
        case didPausePlaying
        case didGoForward
        case didGoBackward
        
        case speedButtonTapped
        case timerTicked(timeInterval: TimeInterval)
    }
    
    enum Rate: Float {
        case half = 0.5
        case normal = 1.0
        case double = 2.0
        
        var title: String {
            switch self {
            case .half: return "Speed 0.5x"
            case .normal: return "Speed 1x"
            case .double: return "Speed 2x"
            }
        }
        
        mutating func toggle() {
            switch self {
            case .half: self = .normal
            case .normal: self = .double
            case .double: self = .half
            }
        }
    }
    
    enum CancelID {
        case timer
    }
    
    @Dependency(\.audioPlayer) var audioPlayer
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Scope(state: \.progressViewState, action: /Action.progressViewAction) { PlayerTimeProgressDomain() }
        
        Reduce { state, action in
            switch action {
            case .progressViewAction:
                return .none
                
            case let .didReceiveItemUrl(itemUrl):
                return .run { send in
                    do {
                        let isItemLoaded = try await audioPlayer.load(itemUrl)
                        await send(.didLoadItemUrl(success: isItemLoaded))
                    } catch {
                        print(error)
                        await send(.didFailedToLoadItem(error: error))
                    }
                }
                
            case .didStartPlaying:
                return .run {[rate = state.rate] send in
                    _ = try await audioPlayer.play()
                    
                    for await _ in clock.timer(interval: .seconds(Double(1 / rate.rawValue))) {
                        let currentTime = await audioPlayer.currentTimeInterval()
                        await send(.timerTicked(timeInterval: currentTime))
                    }
                }
                .cancellable(id: CancelID.timer)
                
            case .didPausePlaying:
                return .merge(
                    .run { send in
                        await audioPlayer.pause()
                    },
                    .cancel(id: CancelID.timer)
                )
                
            case .didGoForward:
                return .run { _ in
                    await audioPlayer.advancedTime(10.0)
                }
                
            case .didGoBackward:
                return .run { _ in
                    await audioPlayer.advancedTime(-5.0)
                }
                
            case .didLoadItemUrl:
                return .run { send in
                    let duration = await audioPlayer.maxDuration()
                    await send(.didReceiveItemDuration(duration: duration))
                }
                
            case .didFailedToLoadItem:
                return .none
                
            case let .didReceiveItemDuration(duration):
                state.progressViewState.currentTimeInterval = 0.0
                state.progressViewState.maxTimeInterval = duration
                state.progressViewState.playerProgressState.maxTimeInterval = duration
                return .none
                
            case .speedButtonTapped:
                state.rate.toggle()
                return .merge(
                    .run {[rate = state.rate] send in
                        await audioPlayer.setRate(rate.rawValue)
                        
                        let currentTime = await audioPlayer.currentTimeInterval()
                        await send(.timerTicked(timeInterval: currentTime))
                        
                        await send(.didStartPlaying)
                    },
                    .cancel(id: CancelID.timer)
                )
                
            case let .timerTicked(timeInterval):
                state.progressViewState.currentTimeInterval = round(timeInterval)
                state.progressViewState.playerProgressState.currentTimeInterval = timeInterval
                return .none
            }
        }
    }
}
