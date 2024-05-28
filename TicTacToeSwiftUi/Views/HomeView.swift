//
//  HomeView.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 27/05/24.
//

import SwiftUI

struct HomeView: View {
    @State private var navPath = NavigationPath()
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack (alignment: .center, spacing: 20) {
                Spacer()
                Text("Tic Tac Toe")
                    .font(.system(size: 30, weight: .heavy, design: .serif))
                    .italic()
                    .padding()
                Button("Real-Time multiplayer") {
                    navPath.append(1)
                }
                .buttonStyle(GrowingButton())
                Button("Play with AI") {
                    navPath.append(2)
                }
                .buttonStyle(GrowingButton())
                Spacer()
            }.navigationDestination(for: Int.self) { id in
                if id == 2 {
                    HumanVsAIBoard()
                } else {
                    OnlineGameBoard()
                }
                
            }
        }
    }
}

#Preview {
    HomeView()
}
