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
                    Text("Human : \(viewModel.humanScore)")
                    Spacer()
                    Text("Computer : \(viewModel.computerScore)")
                    Spacer()
                }
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.red)
                                .opacity(0.8)
                                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 15)
                            Button(action: {
                                viewModel.processPlayerMove(at: i)
                            }, label: {
                                Image(systemName: viewModel.moves[i]?.markingImage ?? "")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: (geometry.size.width/3 - 15)*0.4, height: (geometry.size.width/3 - 15)*0.4)
                            })
                        }
                    }
                }
                Spacer()
                Button (action: {
                    viewModel.resetGame()
                }, label: {
                    ButtonView(text: "Reset Game", textColour: .primary, backgroundColour: .red)
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                })
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

struct Move {
    var player: Player
    var boardIndex: Int
    
    var markingImage: String {
        return player == .human ? "circle": "xmark"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HumanVsAIBoard()
    }
}

struct ButtonView: View {
    var text: String
    var textColour: Color
    var backgroundColour: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 20, weight: .bold, design: .default))
            .frame(width: 200, height: 50)
            .foregroundColor(textColour)
            .background(backgroundColour)
            .cornerRadius(5)
    }
}
