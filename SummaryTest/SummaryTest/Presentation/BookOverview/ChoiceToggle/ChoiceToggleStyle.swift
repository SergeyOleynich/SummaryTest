//
//  ChoiceToggleStyle.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 06.11.2023.
//

import SwiftUI

import Colors

struct ChoiceToggleStyle: ToggleStyle {
    let rightChoiceImage: Image
    let leftChoiceImage: Image
    
    private var imageOffset: CGFloat {
        (Constants.toggleSize.width - Constants.toggleSize.height) / 2.0
    }
    
    func makeBody(configuration: Configuration) -> some View {
        Capsule()
            .strokeBorder(Color._e5e5e5, lineWidth: Constants.borderWidth)
            .background(Capsule().fill(.white))
            .overlay(
                rightChoiceImage
                    .foregroundColor(Color.black)
                    .offset(x: -imageOffset)
            )
            .overlay(
                leftChoiceImage
                    .foregroundColor(Color.black)
                    .offset(x: imageOffset)
            )
            .overlay {
                Circle()
                    .fill(Color._0066ff)
                    .padding(Constants.cornerRadius)
                    .overlay {
                        Group {
                            if configuration.isOn {
                                leftChoiceImage
                            }
                            else {
                                rightChoiceImage
                            }
                        }
                        .foregroundColor(Color.white)
                    }
                    .offset(x: configuration.isOn ? imageOffset : -imageOffset)
            }
            .frame(
                width: Constants.toggleSize.width,
                height: Constants.toggleSize.height)
            .onTapGesture {
                withAnimation(.spring()) {
                    configuration.isOn.toggle()
                }
            }
    }
}

// MARK: - Constants

private extension ChoiceToggleStyle {
    enum Constants {
        static let toggleSize = CGSize(width: 110, height: 60)
        static let borderWidth = 2.0
        static let cornerRadius = 4.0
    }
}

// MARK: - Preview

struct ChoiceTogglePreview: View {
    @State private var isOn = true
    
    var body: some View {
        Toggle("", isOn: $isOn)
            .toggleStyle(
                ChoiceToggleStyle(
                    rightChoiceImage: Image(systemName: "pencil"),
                    leftChoiceImage: Image(systemName: "eraser"))
            )
    }
}

struct ChoiceToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        ChoiceTogglePreview()
    }
}
