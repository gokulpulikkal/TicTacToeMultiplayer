//
//  OnlineGameBoard.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul P on 27/05/24.
//

import SwiftUI
import SwiftfulLoadingIndicators

struct OnlineGameBoard: View {
    @StateObject var viewModel = OnlineGameBoardViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var showHomePopup: Bool = false
    @State var showResetPopup: Bool = false
    
    var body: some View {
        GeometryReader { (geometry) in
            ZStack {
                gameBoard(geometry)
                    .allowsHitTesting(!viewModel.isDisabled)
                if viewModel.isDisabled {
                    loadingIndicator()
                }
                homeButton()
                resetButton()
                if showResetPopup {
                    resetPopupDialog()
                }
                if showHomePopup {
                    homePopupDialog()
                }
                if !viewModel.isGameStarted {
                    OnlineGameLauncher(onSelectingOption: { selectedOption in
                        
                        switch selectedOption {
                        case .join_room_and_play:
                            print("Join room and play")
                        case .match_with_random_player:
                            viewModel.connectToWebSocket()
                        case .go_home:
                            presentationMode.wrappedValue.dismiss()
                        case .canceled_game_init:
                            print("Cancel the game init")
                        }
                    })
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func loadingIndicator() -> some View {
        ZStack {
            VStack(spacing: -20) {
                Spacer()
                LoadingIndicator(color: .red, size: .large)
                    .opacity(0.8)
                Text("Opponent's turn")
                    .bold()
                    .font(.title2)
                    .padding([.bottom], 50)
            }
        }.ignoresSafeArea()
    }
    
    func homeButton() -> some View {
        HStack {
            VStack {
                Button {
                    showHomePopup.toggle()
                } label: {
                    Image(systemName: "house.fill")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                        .tint(.red)
                        .opacity(0.8)
                }
                Spacer()
            }
            .padding([.leading])
            Spacer()
                
        }
    }
    
    func resetButton() -> some View {
        HStack {
            Spacer()
            VStack {
                Button {
                    showResetPopup.toggle()
                } label: {
                    Image(systemName: "arrow.uturn.left.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32)
                        .tint(.red)
                        .opacity(0.8)
                }
                Spacer()
            }
            .padding([.trailing])
        }
    }
    
    func homePopupDialog() -> some View {
        CustomDialogPopup(
            title: "You Really wanna go Home?",
            subTitle: "Your current match will be terminated!",
            buttons: [
                DialogButton(title: "cancel", action: {
                    showHomePopup.toggle()
                }),
                DialogButton(title: "Go Home", action: {
                    presentationMode.wrappedValue.dismiss()
                })
            ],
            buttonAxis: .horizontal
        )
    }
    
    func resetPopupDialog() -> some View {
        CustomDialogPopup(
            title: "You wanna reset?",
            subTitle: "Your current match progress will be lost",
            buttons: [
                DialogButton(title: "cancel", action: {
                    showResetPopup.toggle()
                }),
                DialogButton(title: "Reset", action: {
                    viewModel.resetGame()
                    showResetPopup.toggle()
                })
            ],
            buttonAxis: .horizontal
        )
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
            Spacer()
            
        }
        .padding()
        .alert(item: $viewModel.alertVariable) { (alertVariable) -> Alert in
            Alert(title: alertVariable.title,
                  message: alertVariable.message,
                  primaryButton: .default(alertVariable.buttonText, action: {
                    viewModel.resetGame()
                    viewModel.alertVariable = nil
            }),
                  secondaryButton: .default(Text("Cancel"), action: {
                    viewModel.alertVariable = nil
                    presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}

#Preview {
    OnlineGameBoard()
}
