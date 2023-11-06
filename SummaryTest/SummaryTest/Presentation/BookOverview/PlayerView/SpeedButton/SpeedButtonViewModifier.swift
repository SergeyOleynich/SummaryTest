//
//  SpeedButtonViewModifier.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

import Colors

struct SpeedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .black.opacity(Constants.isPressedOpacity) : .black)
            .fontWeight(.bold)
            .padding(Constants.padding)
            .background(configuration.isPressed ? Color._f2ebe8.opacity(Constants.isPressedOpacity) : Color._f2ebe8)
            .cornerRadius(Constants.cornerRadius)
    }
}

// MARK: - Constans

private extension SpeedButtonStyle {
    enum Constants {
        static let padding: EdgeInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        static let cornerRadius = 4.0
        static let isPressedOpacity = 0.4
    }
}

// MARK: - Preview

struct SpeedButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Speed 1x") {
            
        }
        .buttonStyle(SpeedButtonStyle())
    }
}
