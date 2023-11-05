//
//  PlayProgressView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

private extension PlayerProgressView {
    enum Constants {
        static let knobSize: CGSize = .init(width: 20, height: 20)
        static let knobDraggableSize: CGSize = .init(width: 50, height: 50)
    }
}

struct PlayerProgressView: View {
    @GestureState private var isDragging: Bool = false
    @State private var progress: Double = 0.0
    @State private var lastProgress: Double = 0.0
    
    var body: some View {
        GeometryReader { proxy in
            seekBarView
                .overlay(alignment: .leading) {
                    trackView(seekWidth: proxy.size.width)
                }
                .overlay(alignment: .leading) {
                    knobView(seekWidth: proxy.size.width)
                }
        }
    }
}

// MARK: - ViewBuilders

private extension PlayerProgressView {
    var seekBarView: some View {
        Rectangle()
            .fill(.gray)
    }
    
    func trackView(seekWidth: Double) -> some View {
        Rectangle()
            .fill(.blue)
            .frame(width: max(0, seekWidth * progress))
    }
    
    func knobView(seekWidth: Double) -> some View {
        Circle()
            .fill(.blue)
            .frame(
                width: Constants.knobSize.width,
                height: Constants.knobSize.height)
            .frame(
                width: Constants.knobDraggableSize.width,
                height: Constants.knobDraggableSize.height)
            .contentShape(Rectangle())
            .offset(x: seekWidth * progress)
            .gesture(
                DragGesture()
                    .updating($isDragging, body: { _, out, _ in
                        out = true
                    })
                    .onChanged({ value in
                        let translation = value.translation.width
                        let progress = (translation / seekWidth) + lastProgress
                        
                        self.progress = max(min(progress, 1), 0)
                    })
                    .onEnded({ value in
                        lastProgress = progress
                    }))
            .offset(x: progress * seekWidth > Constants.knobSize.width ? -Constants.knobSize.width : .zero)
            .frame(width: Constants.knobSize.width, height: Constants.knobSize.height)
    }
}

struct PlayProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerProgressView()
            .frame(width: 100)
            .frame(height: 3)
    }
}
