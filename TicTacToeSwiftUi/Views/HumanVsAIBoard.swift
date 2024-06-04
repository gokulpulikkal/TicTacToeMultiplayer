//
//  HumanVsAIBoard.swift
//  TicTacToeSwiftUi
//
//  Created by Gokul on 10/07/21.
//

import SwiftUI

struct HumanVsAIBoard: View {
    @StateObject var viewModel = GameViewModel()
    @State var showHomePopup: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var showResetPopup: Bool = false
    
    var body: some View {
        GeometryReader { (geometry) in
            ZStack{
                homeButton()
                resetButton()
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
                    Spacer()
                }
                .allowsHitTesting(!viewModel.isDisabled)
                .padding()
                .alert(item: $viewModel.alertVariable) { (alertVariable) -> Alert in
                    Alert(title: alertVariable.title,
                          message: alertVariable.message,
                          dismissButton: .default(alertVariable.buttonText, action: {
                        viewModel.resetGame()
                    }))
                }
                if showHomePopup {
                    homePopupDialog()
                }
                if showResetPopup {
                    resetPopupDialog()
                }
            }
            .navigationBarHidden(true)
        }
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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HumanVsAIBoard()
    }
}
