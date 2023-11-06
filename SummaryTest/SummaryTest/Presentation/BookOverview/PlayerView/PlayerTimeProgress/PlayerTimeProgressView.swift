//
//  PlayerTimeProgressView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

import Colors

struct PlayerTimeProgressView: View {
    @Binding var seekWidth: CGFloat
    
    init(seekWidth: Binding<CGFloat> = .constant(0.0)) {
        self._seekWidth = seekWidth
    }
    
    var body: some View {
        HStack {
            Text("--:--")
                .font(.callout.monospacedDigit())
            
            PlayerProgressView()
                .knobSize(Constants.knobSize)
                .seekHeight(Constants.seekHeight)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(
                                key: WidthPreferenceKey.self,
                                value: [proxy.size.width])
                    }
                )
            
            Text("--:--")
                .font(.callout.monospacedDigit())
        }
        .foregroundColor(Color._999592)
        .onPreferenceChange(WidthPreferenceKey.self) { preference in
            seekWidth = preference.first ?? .zero
        }
    }
}

// MARK: - Constans

private extension PlayerTimeProgressView {
    enum Constants {
        static let knobSize = CGSize(width: 25, height: 25)
        static let seekHeight = 6.0
    }
}

// MARK: - Preview

struct PlayerTimeProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerTimeProgressView()
    }
}
