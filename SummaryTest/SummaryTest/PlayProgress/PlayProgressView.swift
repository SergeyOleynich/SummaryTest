//
//  PlayProgressView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

struct PlayProgressView: View {
    @GestureState private var isDragging: Bool = false
    @State private var progress: Double = 0.0
    @State private var lastProgress: Double = 0.0
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(.gray)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(.blue)
                        .frame(width: max(0, proxy.size.width * progress))
                }
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(.blue)
                        .frame(width: 20, height: 20)
                        .frame(width: 100, height: 100)
                        .contentShape(Rectangle())
                        .offset(x: proxy.size.width * progress)
                        .gesture(
                            DragGesture()
                                .updating($isDragging, body: { _, out, _ in
                                    out = true
                                })
                                .onChanged({ value in
                                    let translation = value.translation.width
                                    let progress = (translation / proxy.size.width) + lastProgress
                                    
                                    self.progress = max(min(progress, 1), 0)
                                })
                                .onEnded({ value in
                                    lastProgress = progress
                                }))
                        .offset(x: progress * proxy.size.width > 20 ? -20 : 0)
                        .frame(width: 20, height: 20)
                }
        }
    }
}

struct PlayProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlayProgressView()
            .frame(width: 100)
            .frame(height: 3)
    }
}
