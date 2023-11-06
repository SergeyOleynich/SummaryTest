//
//  BookOverviewView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

import Colors
import ComposableArchitecture

struct SummaryOverviewView: View {
    @State private var isOnT = true
    @State private var seekWidth: CGFloat = 290.0
    @State private var bookImageOffset: CGFloat = 0.0
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Image("AtomicHabits")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.leading, .trailing], 68)
                .background(
                    GeometryReader { geometry -> Color in
                        bookImageOffset = geometry.size.height
                        return .clear
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
            
            choiceView
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

// MARK: - ViewBuilders

private extension SummaryOverviewView {
    @ViewBuilder
    var choiceView: some View {
        Toggle("", isOn: $isOnT)
            .toggleStyle(
                ChoiceToggleStyle(
                    rightChoiceImage: Image(systemName: "headphones"),
                    leftChoiceImage: Image(systemName: "text.alignleft")))
    }
    
    @ViewBuilder
    var purchaseView: some View {
        PurchaseBackgroundView {
            VStack {
                Spacer()
                Spacer()
                PurchaseView()
                Spacer()
            }
        }
    }
}

// MARK: - Constants

private extension SummaryOverviewView {
    enum Constants {
        static let playerControlsHeight = 30.0
        static let contentPadding = 16.0
    }
}

// MARK: - Preview

struct SummaryOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryOverviewView()
    }
}
