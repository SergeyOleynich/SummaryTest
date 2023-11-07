//
//  PurchaseButtonStyle.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 07.11.2023.
//

import SwiftUI

import Colors

struct PurchaseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(configuration.isPressed ? Color._0066ff.opacity(0.5) : Color._0066ff)
            .cornerRadius(4)
    }
}
