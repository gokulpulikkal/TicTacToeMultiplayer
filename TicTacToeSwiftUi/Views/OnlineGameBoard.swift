//
//  OnlineGameBoard.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 27/05/24.
//

import SwiftUI

struct OnlineGameBoard: View {
    @StateObject var viewModel = OnlineGameBoardViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        GeometryReader { (geometry) in
            ZStack {
                gameBoard(geometry)
                OnlineGameLauncher(onSelectingOption: { selectedOption in
                    print("selected option \(selectedOption)")
                    if selectedOption == GameLaunchOptions.go_home {
//                        navPath.removeLast(navPath.count)
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            }
        }
        .navigationBarHidden(true)
    }
    
    func gameBoard(_ geometry: GeometryProxy) -> some View {
        VStack (alignment: .center, spacing: 20) {
            Spacer()
            Text("Tic Tac Toe")
                .font(.system(size: 30, weight: .heavy, design: .serif))
                .italic()
            
            HStack {
                Spacer()
                Text("Wins : \(viewModel.wins)")
                Spacer()
                Text("Loss : \(viewModel.loss)")
                Spacer()
            }
            Spacer()
            LazyVGrid(columns: viewModel.columns, spacing: 5) {
                ForEach(0..<9) { i in
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                            .opacity(0.8)
                            .frame(width: max(geometry.size.width/3 - 15, 0), height: max(geometry.size.width/3 - 15, 0))
                        Button(action: {
                            viewModel.processPlayerMove(at: i)
                        }, label: {
                            Image(systemName: viewModel.moves[i]?.markingImage ?? "")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: max((geometry.size.width/3 - 15)*0.4, 0), height: max((geometry.size.width/3 - 15)*0.4, 0))
                        })
                    }
                }
            }
            Spacer()
            Button("Reset Game") {
                viewModel.resetGame()
            }.buttonStyle(GrowingButton())
            Spacer()
            
        }
        .disabled(viewModel.isDisabled)
        .padding()
        .alert(item: $viewModel.alertVariable) { (alertVariable) -> Alert in
            Alert(title: alertVariable.title,
                  message: alertVariable.message,
                  dismissButton: .default(alertVariable.buttonText, action: {
                viewModel.resetGame()
            }))
        }
    }
}

#Preview {
    OnlineGameBoard()
}
