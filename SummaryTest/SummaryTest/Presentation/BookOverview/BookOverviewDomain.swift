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
        var book: BookItem?
        var activeKeypoint: BookKeyPoint? {
            didSet {
                guard let activeKeypoint = activeKeypoint else {
                    playerState.itemTitle = ""
                    playerState.itemDescription = ""
                    
                    playerControlState.isBackwardActive = false
                    playerControlState.isForwardActive = false
                    return
                }
                
                playerState.itemTitle = keyPointDescription
                playerState.itemDescription = activeKeypoint.description
                
                playerControlState.isBackwardActive = book?.keyPoints.first == activeKeypoint ? false : true
                playerControlState.isForwardActive = book?.keyPoints.last == activeKeypoint ? false : true
            }
        }
        
        var choice: Choice = .listening
        var isLoading: Bool = true
        var isStartPurchasing: Bool = false
        
        var purchaseState: PurchaseViewDomain.State?
        var playerState: PlayerViewDomain.State = .init()
        var playerControlState = PlayerControlDomain.State()
        
        @PresentationState var playerAlert: AlertState<Action.PlayerAlertAction>?
        @PresentationState var storeKitAlert: AlertState<Action.StoreKitAlertAction>?
    }
    
    enum Action {
        case purchaseViewAction(action: PurchaseViewDomain.Action)
        case playerViewAction(action: PlayerViewDomain.Action)
        case playerControlAction(action: PlayerControlDomain.Action)

        case onRequestPurchaseItem
        case didLoadPurchaseItem(item: BookItem)
        case choiceToggleTapped
        
        case didReceivePlayerError(errorMessage: String)
        case didReceiveStoreKitError(errorMessage: String)
        case didPurchase
        
        case playerAlert(PresentationAction<PlayerAlertAction>)
        case storeKitAlert(PresentationAction<StoreKitAlertAction>)
        
        enum PlayerAlertAction: Equatable {
            
        }
        
        enum StoreKitAlertAction: Equatable {
            case ok
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
                
                return .run {[item = state.purchaseState?.item] send in
                    guard let item = item else { return }
                    
                    do {
                        guard try await storeKit.purchase(item) else {
                            await send(.didReceiveStoreKitError(errorMessage: "Could not process"))
                            return
                        }
                        
                        await send(.didPurchase)
                    } catch {
                        await send(.didReceiveStoreKitError(errorMessage: error.localizedDescription))
                    }
                }
                
            case .purchaseViewAction:
                return .none
                
            case let .playerViewAction(.didLoadItemUrl(success)):
                state.playerControlState.isActive = success
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
                //TODO: need to make cancel
                
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
                
            case .playerControlAction(.backwardButtonTapped):
                guard let activeKeypoint = state.activeKeypoint else { return .none }
                guard let index = state.book?.keyPoints.firstIndex(of: activeKeypoint) else { return .none }
                guard let activeKeypoint = state.book?.keyPoints[safe: index - 1] else { return .none }
                
                state.activeKeypoint = activeKeypoint
                return .send(.playerViewAction(action: .didReceiveItemUrl(item: activeKeypoint.url)))
                
            case .playerControlAction(.forwardButtonTapped):
                guard let activeKeypoint = state.activeKeypoint else { return .none }
                guard let index = state.book?.keyPoints.firstIndex(of: activeKeypoint) else { return .none }
                guard let activeKeypoint = state.book?.keyPoints[safe: index + 1] else { return .none }
                
                state.activeKeypoint = activeKeypoint
                return .send(.playerViewAction(action: .didReceiveItemUrl(item: activeKeypoint.url)))
                
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
                state.book = item
                state.activeKeypoint = item.keyPoints.first
                state.purchaseState = .init(item: item)
                
                return .none
                
            case .choiceToggleTapped where state.choice == .listening:
                state.choice = .reading
                return .none
            
            case .choiceToggleTapped where state.choice == .reading:
                state.choice = .listening
                return .none
                
            case .choiceToggleTapped:
                return .none
                
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
                state.storeKitAlert = AlertState {
                    TextState("Failed to process store kit")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Ok!")
                    }
                } message: {
                    TextState(errorMessage)
                }
                return .none
                
            case .didPurchase:
                state.storeKitAlert = AlertState {
                    TextState("Purchase is successful!")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Ok!")
                    }
                } message: {
                    TextState("You Buy IT!")
                }
                
                state.purchaseState = nil
                
                guard let activeKeypoint = state.activeKeypoint else { return .none }

                return .send(.playerViewAction(action: .didReceiveItemUrl(item: activeKeypoint.url)))
                
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

// MARK: - Private

private extension BookOverviewDomain.State {
    var keyPointDescription: String {
        guard let index = book?.keyPoints.firstIndex(where: { $0.id == activeKeypoint?.id ?? 0 }) else { return "" }
        
        return "KEY POINT \(index + 1) OF \(book?.keyPoints.count ?? 0)"
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
