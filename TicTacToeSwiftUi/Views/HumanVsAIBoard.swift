//
//  HumanVsAIBoard.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul on 10/07/21.
//

import SwiftUI

struct HumanVsAIBoard: View {
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { (geometry) in
            
            VStack (alignment: .center, spacing: 20) {
                Spacer()
                Text("Tic Tac Toe")
                    .font(.system(size: 30, weight: .heavy, design: .serif))
                    .italic()
                
                HStack {
                    Spacer()
                    Text("Human : \(viewModel.ownScore)")
                    Spacer()
                    Text("Computer : \(viewModel.oponentScore)")
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
    
}

enum Player {
    case human
    case computer
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HumanVsAIBoard()
    }
}
