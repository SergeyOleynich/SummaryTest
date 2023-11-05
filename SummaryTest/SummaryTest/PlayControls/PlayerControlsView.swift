//
//  PlayerControlsView.swift
//  SummaryTest
//
//  Created by Serhii Oleinich on 05.11.2023.
//

import SwiftUI

struct PlayerControlsView: View {
    var body: some View {
        HStack(spacing: 24.0) {
            Button {
                
            } label: {
                Image(systemName: "backward.end.fill")
            }
            
            Button {
                
            } label: {
                Image(systemName: "gobackward.5")
            }
            .scaleEffect(1.2)
            
            Button {
                
            } label: {
                Image(systemName: "pause.fill")
            }
            .scaleEffect(1.5)
            
            Button {
                
            } label: {
                Image(systemName: "goforward.10")
            }
            .scaleEffect(1.2)
            
            Button {
                
            } label: {
                Image(systemName: "forward.end.fill")
            }
        }
        .font(.system(size: 20))
        .foregroundColor(.black)
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView()
    }
}
