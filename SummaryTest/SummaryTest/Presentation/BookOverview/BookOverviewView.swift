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
    @State private var seekWidth: CGFloat = 290.0
    @State private var bookImageOffset: CGFloat = 0.0
    
    let store: StoreOf<BookOverviewDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .center, spacing: .zero) {
                Image("AtomicHabits")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding([.leading, .trailing], 68)
                    .background(
                        GeometryReader { geometry -> Color in
                            DispatchQueue.main.async {
                                bookImageOffset = geometry.size.height
                            }
                            return Color.clear
                        }
                    )
                
                Spacer(minLength: .zero)
                
                PlayerView(seekWidth: $seekWidth)
                
                Spacer(minLength: .zero)
                
                PlayerControlsView(
                    store: Store(
                        initialState: PlayerControlDomain.State()) { PlayerControlDomain() })
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
    }
}

// MARK: - Preview

struct BookOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        BookOverviewView(
            store: Store(
                initialState: BookOverviewDomain.State()) { BookOverviewDomain() })
    }
}
