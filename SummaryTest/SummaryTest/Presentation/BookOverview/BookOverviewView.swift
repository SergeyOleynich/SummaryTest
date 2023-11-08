//
//  BookOverviewView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

import Colors
import ComposableArchitecture

struct BookOverviewView: View {
    @State private var seekWidth: CGFloat = 0.0
    @State private var bookImageOffset: CGFloat = 0.0
    
    let store: StoreOf<BookOverviewDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .center, spacing: .zero) {
                viewStore.book?.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding([.leading, .trailing], Constants.imagePadding)
                    .background(
                        GeometryReader { geometry -> Color in
                            DispatchQueue.main.async {
                                bookImageOffset = geometry.size.height
                            }
                            return Color.clear
                        }
                    )
                
                Spacer(minLength: .zero)
                
                PlayerView(
                    store: store.scope(state: \.playerState, action: { .playerViewAction(action: $0) }),
                    seekWidth: $seekWidth)
                
                Spacer(minLength: .zero)
                
                PlayerControlsView(
                    store: store.scope(
                            state: \.playerControlState,
                            action: { .playerControlAction(action: $0) }))
                .frame(width: seekWidth)
                .frame(height: Constants.playerControlsHeight)
                
                Spacer(minLength: .zero)
                
                choiceView(viewStore: viewStore)
            }
            .padding([.leading, .trailing], Constants.contentPadding)
            .background(Color._fff8f3)
            .overlay(
                purchaseView
                    .padding(.top, bookImageOffset)
                    .ignoresSafeArea(edges: .bottom)
            )
            .task { viewStore.send(.onRequestPurchaseItem) }
            .alert(store: store.scope(state: \.$playerAlert, action: { .playerAlert($0) }))
            .alert(store: store.scope(state: \.$storeKitAlert, action: { .storeKitAlert($0) }))
            .opacity(viewStore.isLoading ? 0.0 : 1.0)
        }
    }
}

// MARK: - ViewBuilders

private extension BookOverviewView {
    func choiceView(viewStore: ViewStore<BookOverviewDomain.State, BookOverviewDomain.Action>) -> some View {
        Toggle("",
               isOn: Binding(
                get: { viewStore.choice == .reading },
                set: { _ in viewStore.send(.choiceToggleTapped) }))
            .toggleStyle(
                ChoiceToggleStyle(
                    rightChoiceImage: Image(systemName: "headphones"),
                    leftChoiceImage: Image(systemName: "text.alignleft")))
    }
    
    @ViewBuilder
    var purchaseView: some View {
        IfLetStore(
            store.scope(
                state: \.purchaseState,
                action: { .purchaseViewAction(action: $0) })
        ) { purchaseStore in
            PurchaseBackgroundView {
                Spacer()
                Spacer()
                PurchaseView(store: purchaseStore)
                Spacer()
            }
        }
    }
}

// MARK: - Constants

private extension BookOverviewView {
    enum Constants {
        static let playerControlsHeight = 30.0
        static let contentPadding = 16.0
        static let imagePadding = 68.0
    }
}

// MARK: - Preview

#if DEBUG
struct BookOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        BookOverviewView(
            store: Store(
                initialState: BookOverviewDomain.State()) { BookOverviewDomain() })
    }
}
#endif
