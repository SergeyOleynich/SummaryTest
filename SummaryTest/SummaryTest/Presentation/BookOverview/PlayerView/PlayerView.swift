//
//  PlayerView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

import Colors
import ComposableArchitecture

struct PlayerView: View {
    @Binding var seekWidth: CGFloat
    
    init(seekWidth: Binding<CGFloat> = .constant(290)) {
        self._seekWidth = seekWidth
    }
    
    var body: some View {
        VStack(spacing: 16.0) {
            VStack(alignment: .center, spacing: 8.0) {
                Text("KEY POINT 2 OF 10")
                    .font(.system(.headline))
                    .foregroundColor(Color._999592)
                
                Text("Design is not how thing looks, but how it works")
                    .font(.system(.subheadline))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .frame(width: seekWidth)
            
            PlayerTimeProgressView(seekWidth: $seekWidth)

            Button("Speed 1x") {

            }
            .buttonStyle(SpeedButtonStyle())
        }
    }
}

// MARK: - Constans

private extension PlayerView {
    enum Constants {
        static let knobSize = CGSize(width: 25, height: 25)
        static let seekHeight = 6.0
    }
}

// MARK: - Preview

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
