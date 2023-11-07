//
//  PlayerProgressView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

import Colors
import ComposableArchitecture

struct PlayerProgressView: View {
    @State private var lastProgress: Double = 0.0
    
    @GestureState private var isDragging: Bool = false
    
    private var knobSize: CGSize = Constants.knobSize
    private var seekHeight: Double = Constants.seekHeight
    
    let store: StoreOf<PlayerProgressDomain>
    
    init(store: StoreOf<PlayerProgressDomain>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { proxy in
                VStack(spacing: .zero) {
                    Spacer(minLength: .zero)
                    
                    seekBarView
                        .overlay(alignment: .leading) {
                            trackView(progress: viewStore.progress, seekWidth: proxy.size.width)
                        }
                        .overlay(alignment: .leading) {
                            knobView(progress: viewStore.progress, seekWidth: proxy.size.width)
                        }
                    
                    Spacer(minLength: .zero)
                }
                .onChange(of: viewStore.currentTimeInterval) { newValue in
                    
                }
            }
            .frame(height: knobSize.height)
        }
    }
}

// MARK: - Public

extension PlayerProgressView {
    func knobSize(_ size: CGSize) -> PlayerProgressView {
        var copy = self
        copy.knobSize = size
        return copy
    }
    
    func seekHeight(_ height: Double) -> PlayerProgressView {
        var copy = self
        copy.seekHeight = height
        return copy
    }
}

// MARK: - ViewBuilders

private extension PlayerProgressView {
    @ViewBuilder
    var seekBarView: some View {
        Capsule()
            .fill(Color._e5dfdc)
            .frame(height: seekHeight)
    }
    
    func trackView(progress: Double, seekWidth: Double) -> some View {
        Capsule()
            .fill(Color._0066ff)
            .frame(width: max(0, seekWidth * progress))
    }
    
    func knobView(progress: Double, seekWidth: Double) -> some View {
        Circle()
            .fill(Color._0066ff)
            .frame(
                width: knobSize.width,
                height: knobSize.height)
            .frame(
                width: knobSize.width + Constants.knobDraggableOffset.horizontal,
                height: knobSize.height + Constants.knobDraggableOffset.vertical)
            .contentShape(Rectangle())
            .offset(x: seekWidth * progress)
//            .gesture(
//                DragGesture()
//                    .updating($isDragging, body: { _, out, _ in
//                        out = true
//                    })
//                    .onChanged({ value in
//                        let translation = value.translation.width
//                        let progress = (translation / seekWidth) + lastProgress
//
//                        self.progress = max(min(progress, 1), 0)
//                    })
//                    .onEnded({ value in
//                        lastProgress = progress
//                    }))
            .offset(x: progress * seekWidth > knobSize.width ? -knobSize.width : .zero)
            .frame(width: knobSize.width, height: knobSize.height)
    }
}

// MARK: - Constants

private extension PlayerProgressView {
    enum Constants {
        static let knobSize: CGSize = .init(width: 20, height: 20)
        static let knobDraggableOffset: UIOffset = .init(horizontal: 30, vertical: 30)
        static let seekHeight: CGFloat = 3.0
    }
}

// MARK: - Preview

struct PlayProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerProgressView(
            store: Store(initialState: PlayerProgressDomain.State(currentTimeInterval: 0.0)) { PlayerProgressDomain() })
            .seekHeight(6)
            .frame(width: 100)
            .background(Color.red)
    }
}
