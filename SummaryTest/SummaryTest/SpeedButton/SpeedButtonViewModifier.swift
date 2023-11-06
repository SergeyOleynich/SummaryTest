//
//  SpeedButtonViewModifier.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

import Colors

struct SpeedButtonViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .fontWeight(.bold)
            .padding(Constants.padding)
            .background(Color._f2ebe8)
            .cornerRadius(Constants.cornerRadius)
    }
}

// MARK: - Constans

private extension SpeedButtonViewModifier {
    enum Constants {
        static let padding: EdgeInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        static let cornerRadius = 4.0
    }
}

// MARK: - Preview

struct SpeedButtonViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Button("Speed 1x") {
            
        }
        .modifier(SpeedButtonViewModifier())
    }
}
