//
//  BookOverviewDomain.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import SwiftUI

import ComposableArchitecture
import AVFoundation
import StoreKit

struct BookOverviewDomain: Reducer {
    struct State: Equatable {
        var choice: Choice = .listening
        var isLoading: Bool = true
        var isStartPurchasing: Bool = false
        
        var purchaseState: PurchaseViewDomain.State?
        var playerState: PlayerViewDomain.State = .init()
        var playerControlState = PlayerControlDomain.State()
        
        @PresentationState var playerAlert: AlertState<Action.Alert>?
        @PresentationState var storeKitAlert: AlertState<Action.Alert>?
    }
    
    enum Action {
        case purchaseViewAction(action: PurchaseViewDomain.Action)
        case playerViewAction(action: PlayerViewDomain.Action)
        case playerControlAction(action: PlayerControlDomain.Action)

        case onRequestPurchaseItem
        case didLoadPurchaseItem(item: Product)
        case purchaseFinished
        case choiceToggleTapped
        
        case didReceivePlayerError(errorMessage: String)
        case didReceiveStoreKitError(errorMessage: String)
        
        case playerAlert(PresentationAction<Alert>)
        case storeKitAlert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            
        }
    }
    
    enum Choice {
        case listening
        case reading
    }
    
    @Dependency(\.storeKit) var storeKit
    @Dependency(\.audioPlayer) var audioPlayer
    
    var body: some ReducerOf<Self> {
        Scope(state: \.playerState, action: /Action.playerViewAction) { PlayerViewDomain() }
        Scope(state: \.playerControlState, action: /Action.playerControlAction) { PlayerControlDomain() }

        Reduce { state, action in
            switch action {
            case .purchaseViewAction(.purchasedButtonTapped):
                state.isStartPurchasing = true
                
                return .run {[item = state.purchaseState?.product] send in
                    guard let item = item else { return }
                    
                    guard let _ = try await storeKit.purchase(item) else { return }
                    
                    await send(.purchaseFinished)
                }
                
            case .purchaseViewAction:
                return .none
                
            case let .playerViewAction(.didLoadItemUrl(success)) where success == true:
                state.playerControlState.isActive.toggle()
                return .none
            
            case .playerViewAction(.didReceiveItemUrl):
                return .run { send in
                    do {
                        for try await _ in audioPlayer.observe() {
                            await send(.playerControlAction(action: .toggleActionButton))
                            await send(.playerViewAction(action: .didFinishPlaying))
                        }
                    } catch {
                        await send(.didReceivePlayerError(errorMessage: error.localizedDescription))
                    }
                }
                
            case .playerViewAction:
                return .none
                
            case .playerControlAction(.playButtonTapped):
                return .send(.playerViewAction(action: .didStartPlaying))
            
            case .playerControlAction(.pauseButtonTapped):
                return .send(.playerViewAction(action: .didPausePlaying))
            
            case .playerControlAction(.goBackwardButtonTapped):
                return .send(.playerViewAction(action: .didGoBackward))
                
            case .playerControlAction(.goForwardButtonTapped):
                return .send(.playerViewAction(action: .didGoForward))
                
            case .playerControlAction:
                return .none

            case .onRequestPurchaseItem:
                return .run { send in
                    do {
                        guard let product = try await storeKit.product() else {
                            return
                        }
                        
                        await send(.didLoadPurchaseItem(item: product))
                    } catch {
                        await send(.didReceiveStoreKitError(errorMessage: error.localizedDescription))
                    }
                }
                
            case let .didLoadPurchaseItem(item):
                state.isLoading = false
                state.purchaseState = .init(product: item)
                return .none
                
            case .choiceToggleTapped where state.choice == .listening:
                state.choice = .reading
                return .none
            
            case .choiceToggleTapped where state.choice == .reading:
                state.choice = .listening
                return .none
                
            case .choiceToggleTapped:
                return .none
                
            case .purchaseFinished:
                state.purchaseState = nil
                let itemUrl = Bundle.main.url(forResource: "Summary_of_Atomic_Habits", withExtension: "mp3")!
                
                return .send(.playerViewAction(action: .didReceiveItemUrl(itemUrl: itemUrl)))
                
            case let .didReceivePlayerError(errorMessage):
                state.playerAlert = AlertState {
                    TextState("Failed to process player item")
                  } actions: {
                    ButtonState(role: .cancel) {
                      TextState("Ok!")
                    }
                  } message: {
                    TextState(errorMessage)
                  }
                return .none
            
            case let .didReceiveStoreKitError(errorMessage):
                state.playerAlert = AlertState {
                    TextState("Failed to process store kit")
                  } actions: {
                    ButtonState(role: .cancel) {
                      TextState("Ok!")
                    }
                  } message: {
                    TextState(errorMessage)
                  }
                return .none
                
            case .playerAlert:
                return .none
                
            case .storeKitAlert:
                return .none
            }
        }
        
        .ifLet(\.purchaseState, action: /Action.purchaseViewAction) {
            PurchaseViewDomain()
        }
        
        .ifLet(\.$playerAlert, action: /Action.playerAlert)
        .ifLet(\.$storeKitAlert, action: /Action.storeKitAlert)
    }
}
