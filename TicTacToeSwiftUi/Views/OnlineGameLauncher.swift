//
//  OnlineGameLauncher.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 27/05/24.
//

import SwiftUI

enum GameLaunchOptions: Int {
    case match_with_random_player = 0
    case join_room_and_play = 1
    case go_home = 2
    case canceled_game_init = 3
}

struct OnlineGameLauncher: View {
    @State var title = "Let's Begin Game"
    @State var isGameStarting: Bool = false
    @State var animateLoader: Bool = false
    
    var onSelectingOption: (GameLaunchOptions) -> Void
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.7)
            ZStack {
                launcherOptions
                    .opacity(isGameStarting ? 0: 1)
                loadingView
                    .opacity(isGameStarting ? 1: 0)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            
        }.ignoresSafeArea()
    }
    
    var launcherOptions: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title2)
                .bold()
                .padding()
            Button("Match With Random Player") {
                isGameStarting = true
                onSelectingOption(GameLaunchOptions.match_with_random_player)
            }
            .buttonStyle(GrowingButton())
            Button("Join Room And Play") {
                isGameStarting = true
                onSelectingOption(GameLaunchOptions.join_room_and_play)
            }
            .buttonStyle(GrowingButton())
            Button("Go Home") {
                onSelectingOption(GameLaunchOptions.go_home)
            }
            .buttonStyle(GrowingButton())
        }
        .padding()
    }
    
    var loadingView: some View {
        VStack {
            Circle()
                .stroke(AngularGradient(gradient: .init(colors: [Color.red, Color.primary.opacity(0)]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/), lineWidth: 5)
                .frame(width: 80, height: 80)
                .rotationEffect(.init(degrees: animateLoader ? 360: 0))
                .onAppear{
                    withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        animateLoader.toggle()
                    }
                }
            Text("Waiting for the opponent to join")
                .font(.title2)
                .bold()
                .padding()
            Button("Cancel") {
                isGameStarting = false
                onSelectingOption(GameLaunchOptions.canceled_game_init)
            }
            .buttonStyle(GrowingButton())
        }
    }
}

#Preview {
    OnlineGameLauncher(onSelectingOption: { selectedOption in
        print("selected option \(selectedOption)")
    })
}
