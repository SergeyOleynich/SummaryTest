//
//  PlayerTimeProgressView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

import Colors

struct PlayerTimeProgressView: View {
    var body: some View {
        HStack {
            Text("00:00")
                .font(.callout.monospacedDigit())
            
            PlayerProgressView()
                .frame(height: 3.0)
            
            Text("10:00")
                .font(.callout.monospacedDigit())
        }
        .foregroundColor(Color._999592)
    }
}

// MARK: - Preview

struct PlayerTimeProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerTimeProgressView()
    }
}
